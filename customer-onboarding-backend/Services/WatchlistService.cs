using System.Globalization;
using System.Security.Cryptography;
using System.Text;
using System.Text.Json;
using ClosedXML.Excel;
using CustomerOnboarding.Backend.Data;
using CustomerOnboarding.Backend.Dtos;
using CustomerOnboarding.Backend.Models;
using Microsoft.EntityFrameworkCore;

namespace CustomerOnboarding.Backend.Services;

public class WatchlistService(AppDbContext dbContext) : IWatchlistService
{
  private const int MaximumImportRows = 10_000;
  private const int MaximumPageSize = 250;
  private static readonly string[] RequiredImportHeaders = ["fullname", "screeningcategory", "sourcelist"];

  public async Task<WatchlistPagedResponseDto> GetPagedAsync(WatchlistQueryDto request, CancellationToken cancellationToken = default)
  {
    var page = Math.Max(1, request.Page);
    var pageSize = request.PageSize == -1 ? MaximumPageSize : Math.Clamp(request.PageSize, 10, MaximumPageSize);
    var query = dbContext.WatchlistEntries.AsNoTracking().AsQueryable();

    if (!string.IsNullOrWhiteSpace(request.Search))
    {
      var pattern = $"%{request.Search.Trim()}%";
      query = query.Where(x =>
        EF.Functions.ILike(x.FullName, pattern) ||
        (x.AlternateNames != null && EF.Functions.ILike(x.AlternateNames, pattern)) ||
        (x.SourceReference != null && EF.Functions.ILike(x.SourceReference, pattern)) ||
        (x.DocumentNumber != null && EF.Functions.ILike(x.DocumentNumber, pattern)) ||
        (x.Organization != null && EF.Functions.ILike(x.Organization, pattern)) ||
        EF.Functions.ILike(x.SourceList, pattern));
    }

    if (!string.IsNullOrWhiteSpace(request.Category))
    {
      var category = NormalizeCategory(request.Category);
      if (!string.IsNullOrEmpty(category))
      {
        query = query.Where(x => x.ScreeningCategory == category);
      }
    }

    if (!string.IsNullOrWhiteSpace(request.SourceList))
    {
      var pattern = $"%{request.SourceList.Trim()}%";
      query = query.Where(x => EF.Functions.ILike(x.SourceList, pattern));
    }

    if (request.IsActive.HasValue)
    {
      query = query.Where(x => x.IsActive == request.IsActive.Value);
    }

    var totalRecords = await query.CountAsync(cancellationToken);
    var activeRecords = await query.CountAsync(x => x.IsActive, cancellationToken);
    var pepRecords = await query.CountAsync(x => x.IsPep, cancellationToken);
    var sanctionRecords = await query.CountAsync(x => x.IsSanctioned, cancellationToken);
    var totalPages = Math.Max(1, (int)Math.Ceiling(totalRecords / (double)pageSize));
    page = Math.Min(page, totalPages);

    var items = await query
      .OrderByDescending(x => x.IsActive)
      .ThenBy(x => x.FullName)
      .ThenBy(x => x.SourceList)
      .Skip((page - 1) * pageSize)
      .Take(pageSize)
      .Select(x => ToDto(x))
      .ToListAsync(cancellationToken);

    return new WatchlistPagedResponseDto(page, pageSize, totalRecords, totalPages, activeRecords, pepRecords, sanctionRecords, items);
  }

  public async Task<WatchlistEntryDto?> GetByIdAsync(string id, CancellationToken cancellationToken = default)
  {
    if (!Guid.TryParse(id, out var parsedId))
    {
      return null;
    }

    var entry = await dbContext.WatchlistEntries.AsNoTracking().FirstOrDefaultAsync(x => x.Id == parsedId, cancellationToken);
    return entry is null ? null : ToDto(entry);
  }

  public async Task<WatchlistEntryDto> CreateAsync(UpsertWatchlistEntryRequest request, string userName, CancellationToken cancellationToken = default)
  {
    var values = NormalizeRequest(request);
    var key = BuildEntryKey(values);
    var exists = await dbContext.WatchlistEntries.AnyAsync(x => x.EntryKey == key, cancellationToken);
    if (exists)
    {
      throw new InvalidOperationException("A matching watchlist record already exists. Update the existing record instead.");
    }

    var now = DateTimeOffset.UtcNow;
    var entry = new WatchlistEntry
    {
      Id = Guid.NewGuid(),
      EntryKey = key,
      CreatedAtUtc = now,
      UpdatedAtUtc = now,
      CreatedByUserName = userName,
      UpdatedByUserName = userName
    };

    ApplyValues(entry, values);
    dbContext.WatchlistEntries.Add(entry);
    await dbContext.SaveChangesAsync(cancellationToken);
    return ToDto(entry);
  }

  public async Task<WatchlistEntryDto?> UpdateAsync(string id, UpsertWatchlistEntryRequest request, string userName, CancellationToken cancellationToken = default)
  {
    if (!Guid.TryParse(id, out var parsedId))
    {
      return null;
    }

    var entry = await dbContext.WatchlistEntries.FirstOrDefaultAsync(x => x.Id == parsedId, cancellationToken);
    if (entry is null)
    {
      return null;
    }

    var values = NormalizeRequest(request);
    var key = BuildEntryKey(values);
    var duplicate = await dbContext.WatchlistEntries.AnyAsync(x => x.Id != entry.Id && x.EntryKey == key, cancellationToken);
    if (duplicate)
    {
      throw new InvalidOperationException("Another watchlist record already has the same source, reference, and identity details.");
    }

    entry.EntryKey = key;
    entry.UpdatedAtUtc = DateTimeOffset.UtcNow;
    entry.UpdatedByUserName = userName;
    ApplyValues(entry, values);
    await dbContext.SaveChangesAsync(cancellationToken);
    return ToDto(entry);
  }

  public async Task<bool> DeleteAsync(string id, CancellationToken cancellationToken = default)
  {
    if (!Guid.TryParse(id, out var parsedId))
    {
      return false;
    }

    var entry = await dbContext.WatchlistEntries.FirstOrDefaultAsync(x => x.Id == parsedId, cancellationToken);
    if (entry is null)
    {
      return false;
    }

    dbContext.WatchlistEntries.Remove(entry);
    await dbContext.SaveChangesAsync(cancellationToken);
    return true;
  }

  public async Task<WatchlistImportResultDto> ImportAsync(Stream stream, string fileName, string userName, CancellationToken cancellationToken = default)
  {
    using var workbook = new XLWorkbook(stream);
    var worksheet = FindImportWorksheet(workbook);
    if (worksheet is null)
    {
      throw new InvalidOperationException("The workbook must contain a worksheet named 'Watchlist Import' with Full Name, Screening Category, and Source List columns.");
    }

    var headerRow = worksheet.FirstRowUsed();
    if (headerRow is null)
    {
      throw new InvalidOperationException("The Watchlist Import worksheet is empty.");
    }

    var headers = BuildHeaderMap(headerRow);
    var missingHeaders = RequiredImportHeaders.Where(header => !headers.ContainsKey(header)).ToList();
    if (missingHeaders.Count > 0)
    {
      throw new InvalidOperationException($"Missing required column(s): {string.Join(", ", missingHeaders.Select(FormatHeader))}.");
    }

    var rows = worksheet.RowsUsed().Where(row => row.RowNumber() > headerRow.RowNumber()).ToList();
    if (rows.Count > MaximumImportRows)
    {
      throw new InvalidOperationException($"The import contains {rows.Count:N0} rows. The maximum allowed is {MaximumImportRows:N0} rows.");
    }

    var errors = new List<string>();
    var parsedRows = new List<ParsedImportRow>();
    var skippedBlankRows = 0;

    foreach (var row in rows)
    {
      var rawValues = BuildRawValues(row, headers);
      if (rawValues.Values.All(string.IsNullOrWhiteSpace))
      {
        skippedBlankRows += 1;
        continue;
      }

      try
      {
        var request = new UpsertWatchlistEntryRequest(
          ReadValue(rawValues, "fullname"),
          ReadValue(rawValues, "alternatenames", "aliases", "alias"),
          ReadValue(rawValues, "screeningcategory", "category"),
          ReadValue(rawValues, "sourcelist", "sourcename"),
          ReadValue(rawValues, "sourcereference", "referencenumber", "reference"),
          ReadValue(rawValues, "risklevel", "risk"),
          ReadValue(rawValues, "nationality"),
          ParseDate(ReadValue(rawValues, "dateofbirth", "dob"), "Date Of Birth", row.RowNumber()),
          ReadValue(rawValues, "placeofbirth"),
          ReadValue(rawValues, "documenttype", "idtype"),
          ReadValue(rawValues, "documentnumber", "idnumber"),
          ReadValue(rawValues, "positionorrole", "position", "role"),
          ReadValue(rawValues, "organization", "employer"),
          ReadValue(rawValues, "country"),
          ReadValue(rawValues, "cityorregion", "cityregion", "region"),
          ReadValue(rawValues, "address"),
          ParseDate(ReadValue(rawValues, "listedon", "listingdate"), "Listed On", row.RowNumber()),
          ParseDate(ReadValue(rawValues, "expirydate", "expiry"), "Expiry Date", row.RowNumber()),
          ParseBoolean(ReadValue(rawValues, "isactive"), true, "Is Active", row.RowNumber()),
          ParseBoolean(ReadValue(rawValues, "ispep"), false, "Is PEP", row.RowNumber()),
          ParseBoolean(ReadValue(rawValues, "issanctioned"), false, "Is Sanctioned", row.RowNumber()),
          ParseBoolean(ReadValue(rawValues, "requires enhanced due diligence", "edd required"), false, "Requires Enhanced Due Diligence", row.RowNumber()),
          ReadValue(rawValues, "remarks", "comments", "summary"),
          ReadValue(rawValues, "sourceurl", "medialink", "url")
        );

        var values = NormalizeRequest(request);
        parsedRows.Add(new ParsedImportRow(row.RowNumber(), values, JsonSerializer.Serialize(rawValues)));
      }
      catch (InvalidOperationException ex)
      {
        errors.Add($"Row {row.RowNumber()}: {ex.Message}");
      }
    }

    if (parsedRows.Count == 0 && errors.Count == 0)
    {
      throw new InvalidOperationException("No watchlist entries were found in the import worksheet.");
    }

    if (errors.Count > 0)
    {
      return new WatchlistImportResultDto(worksheet.Name, parsedRows.Count, 0, 0, skippedBlankRows, errors.Take(30).ToList());
    }

    var importKeys = parsedRows.Select(row => BuildEntryKey(row.Values)).Distinct(StringComparer.Ordinal).ToList();
    var existingEntries = await dbContext.WatchlistEntries
      .Where(entry => importKeys.Contains(entry.EntryKey))
      .ToDictionaryAsync(entry => entry.EntryKey, cancellationToken);

    var now = DateTimeOffset.UtcNow;
    var insertedRows = 0;
    var updatedRows = 0;
    foreach (var row in parsedRows)
    {
      var entryKey = BuildEntryKey(row.Values);
      if (existingEntries.TryGetValue(entryKey, out var entry))
      {
        ApplyValues(entry, row.Values);
        entry.UpdatedAtUtc = now;
        entry.UpdatedByUserName = userName;
        entry.ImportedFileName = Path.GetFileName(fileName);
        entry.SourceRowNumber = row.RowNumber;
        entry.SourceDataJson = row.SourceDataJson;
        updatedRows += 1;
        continue;
      }

      entry = new WatchlistEntry
      {
        Id = Guid.NewGuid(),
        EntryKey = entryKey,
        CreatedAtUtc = now,
        UpdatedAtUtc = now,
        CreatedByUserName = userName,
        UpdatedByUserName = userName,
        ImportedFileName = Path.GetFileName(fileName),
        SourceRowNumber = row.RowNumber,
        SourceDataJson = row.SourceDataJson
      };
      ApplyValues(entry, row.Values);
      dbContext.WatchlistEntries.Add(entry);
      existingEntries[entryKey] = entry;
      insertedRows += 1;
    }

    await dbContext.SaveChangesAsync(cancellationToken);
    return new WatchlistImportResultDto(worksheet.Name, parsedRows.Count, insertedRows, updatedRows, skippedBlankRows, []);
  }

  public byte[] BuildImportTemplate()
  {
    using var workbook = new XLWorkbook();
    var worksheet = workbook.Worksheets.Add("Watchlist Import");
    var headers = new[]
    {
      "Full Name", "Alternate Names", "Screening Category", "Source List", "Source Reference", "Risk Level",
      "Nationality", "Date Of Birth", "Place Of Birth", "Document Type", "Document Number", "Position Or Role",
      "Organization", "Country", "City Or Region", "Address", "Listed On", "Expiry Date", "Is Active",
      "Is PEP", "Is Sanctioned", "Requires Enhanced Due Diligence", "Remarks", "Source URL"
    };

    for (var index = 0; index < headers.Length; index += 1)
    {
      worksheet.Cell(1, index + 1).Value = headers[index];
    }

    var headerRange = worksheet.Range(1, 1, 1, headers.Length);
    headerRange.Style.Font.Bold = true;
    headerRange.Style.Font.FontColor = XLColor.White;
    headerRange.Style.Fill.BackgroundColor = XLColor.FromHtml("0B4A26");
    headerRange.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
    worksheet.SheetView.FreezeRows(1);
    worksheet.Row(1).Height = 24;
    worksheet.Columns().AdjustToContents(1, 1);
    worksheet.Columns(1, headers.Length).Style.Alignment.WrapText = true;
    worksheet.Columns(1, headers.Length).Width = 18;
    worksheet.Column(1).Width = 30;
    worksheet.Column(2).Width = 34;
    worksheet.Column(4).Width = 24;
    worksheet.Column(12).Width = 28;
    worksheet.Column(13).Width = 28;
    worksheet.Column(16).Width = 32;
    worksheet.Column(23).Width = 38;
    worksheet.Column(24).Width = 38;

    using var stream = new MemoryStream();
    workbook.SaveAs(stream);
    return stream.ToArray();
  }

  private static IXLWorksheet? FindImportWorksheet(XLWorkbook workbook)
  {
    var namedSheet = workbook.Worksheets.FirstOrDefault(sheet =>
      string.Equals(NormalizeHeader(sheet.Name), "watchlistimport", StringComparison.Ordinal));
    if (namedSheet is not null)
    {
      return namedSheet;
    }

    return workbook.Worksheets.FirstOrDefault(sheet =>
    {
      var headerRow = sheet.FirstRowUsed();
      if (headerRow is null)
      {
        return false;
      }

      var headers = BuildHeaderMap(headerRow);
      return RequiredImportHeaders.All(headers.ContainsKey);
    });
  }

  private static Dictionary<string, int> BuildHeaderMap(IXLRow headerRow)
  {
    return headerRow.CellsUsed()
      .Select(cell => new { Header = NormalizeHeader(cell.GetFormattedString()), Column = cell.Address.ColumnNumber })
      .Where(item => !string.IsNullOrWhiteSpace(item.Header))
      .GroupBy(item => item.Header, StringComparer.OrdinalIgnoreCase)
      .ToDictionary(group => group.Key, group => group.First().Column, StringComparer.OrdinalIgnoreCase);
  }

  private static Dictionary<string, string> BuildRawValues(IXLRow row, IReadOnlyDictionary<string, int> headers)
  {
    return headers.ToDictionary(
      item => item.Key,
      item => row.Cell(item.Value).GetFormattedString().Trim(),
      StringComparer.OrdinalIgnoreCase);
  }

  private static string? ReadValue(IReadOnlyDictionary<string, string> values, params string[] names)
  {
    foreach (var name in names)
    {
      if (values.TryGetValue(NormalizeHeader(name), out var value) && !string.IsNullOrWhiteSpace(value))
      {
        return value.Trim();
      }
    }

    return null;
  }

  private static DateOnly? ParseDate(string? value, string label, int rowNumber)
  {
    if (string.IsNullOrWhiteSpace(value))
    {
      return null;
    }

    if (DateOnly.TryParse(value, CultureInfo.InvariantCulture, DateTimeStyles.None, out var parsedDate) ||
        DateOnly.TryParse(value, CultureInfo.CurrentCulture, DateTimeStyles.None, out parsedDate))
    {
      return parsedDate;
    }

    throw new InvalidOperationException($"{label} must be a valid date.");
  }

  private static bool ParseBoolean(string? value, bool defaultValue, string label, int rowNumber)
  {
    if (string.IsNullOrWhiteSpace(value))
    {
      return defaultValue;
    }

    return value.Trim().ToUpperInvariant() switch
    {
      "TRUE" or "YES" or "Y" or "1" => true,
      "FALSE" or "NO" or "N" or "0" => false,
      _ => throw new InvalidOperationException($"{label} must be Yes/No or True/False.")
    };
  }

  private static NormalizedWatchlistValues NormalizeRequest(UpsertWatchlistEntryRequest request)
  {
    var fullName = Required(request.FullName, "Full Name", 240);
    var category = NormalizeCategory(request.ScreeningCategory);
    if (string.IsNullOrWhiteSpace(category))
    {
      throw new InvalidOperationException("Screening Category must be PEP, SANCTION, WATCHLIST, NBE_RESTRICTED, or INTERNAL_BLACKLIST.");
    }

    var sourceList = Required(request.SourceList, "Source List", 160);
    var normalizedName = NormalizeName(fullName);
    if (string.IsNullOrWhiteSpace(normalizedName))
    {
      throw new InvalidOperationException("Full Name must contain searchable text.");
    }

    return new NormalizedWatchlistValues(
      fullName,
      normalizedName,
      Optional(request.AlternateNames),
      category,
      sourceList,
      Optional(request.SourceReference, 160),
      Optional(request.RiskLevel, 40),
      Optional(request.Nationality, 120),
      request.DateOfBirth,
      Optional(request.PlaceOfBirth, 160),
      Optional(request.DocumentType, 100),
      Optional(request.DocumentNumber, 160),
      Optional(request.PositionOrRole, 240),
      Optional(request.Organization, 240),
      Optional(request.Country, 120),
      Optional(request.CityOrRegion, 160),
      Optional(request.Address),
      request.ListedOn,
      request.ExpiryDate,
      request.IsActive,
      request.IsPep || category == "PEP",
      request.IsSanctioned || category == "SANCTION",
      request.RequiresEnhancedDueDiligence,
      Optional(request.Remarks),
      Optional(request.SourceUrl, 500)
    );
  }

  private static void ApplyValues(WatchlistEntry entry, NormalizedWatchlistValues values)
  {
    entry.FullName = values.FullName;
    entry.NormalizedName = values.NormalizedName;
    entry.AlternateNames = values.AlternateNames;
    entry.ScreeningCategory = values.ScreeningCategory;
    entry.SourceList = values.SourceList;
    entry.SourceReference = values.SourceReference;
    entry.RiskLevel = values.RiskLevel;
    entry.Nationality = values.Nationality;
    entry.DateOfBirth = values.DateOfBirth;
    entry.PlaceOfBirth = values.PlaceOfBirth;
    entry.DocumentType = values.DocumentType;
    entry.DocumentNumber = values.DocumentNumber;
    entry.PositionOrRole = values.PositionOrRole;
    entry.Organization = values.Organization;
    entry.Country = values.Country;
    entry.CityOrRegion = values.CityOrRegion;
    entry.Address = values.Address;
    entry.ListedOn = values.ListedOn;
    entry.ExpiryDate = values.ExpiryDate;
    entry.IsActive = values.IsActive;
    entry.IsPep = values.IsPep;
    entry.IsSanctioned = values.IsSanctioned;
    entry.RequiresEnhancedDueDiligence = values.RequiresEnhancedDueDiligence;
    entry.Remarks = values.Remarks;
    entry.SourceUrl = values.SourceUrl;
  }

  private static WatchlistEntryDto ToDto(WatchlistEntry entry) => new(
    entry.Id.ToString(), entry.FullName, entry.AlternateNames, entry.ScreeningCategory, entry.SourceList,
    entry.SourceReference, entry.RiskLevel, entry.Nationality, entry.DateOfBirth, entry.PlaceOfBirth,
    entry.DocumentType, entry.DocumentNumber, entry.PositionOrRole, entry.Organization, entry.Country,
    entry.CityOrRegion, entry.Address, entry.ListedOn, entry.ExpiryDate, entry.IsActive, entry.IsPep,
    entry.IsSanctioned, entry.RequiresEnhancedDueDiligence, entry.Remarks, entry.SourceUrl,
    entry.ImportedFileName, entry.SourceRowNumber, entry.CreatedByUserName, entry.UpdatedByUserName,
    entry.CreatedAtUtc, entry.UpdatedAtUtc);

  private static string BuildEntryKey(NormalizedWatchlistValues values)
  {
    var raw = string.Join("|", values.SourceList, values.ScreeningCategory, values.SourceReference ?? string.Empty,
      values.NormalizedName, values.DateOfBirth?.ToString("yyyy-MM-dd", CultureInfo.InvariantCulture) ?? string.Empty,
      values.DocumentNumber ?? string.Empty);
    var hash = SHA256.HashData(Encoding.UTF8.GetBytes(NormalizeName(raw)));
    return Convert.ToHexString(hash).ToLowerInvariant();
  }

  private static string Required(string? value, string label, int maxLength)
  {
    var normalized = Optional(value, maxLength);
    return !string.IsNullOrWhiteSpace(normalized)
      ? normalized
      : throw new InvalidOperationException($"{label} is required.");
  }

  private static string? Optional(string? value, int? maxLength = null)
  {
    var normalized = string.IsNullOrWhiteSpace(value) ? null : value.Trim();
    if (normalized is not null && maxLength.HasValue && normalized.Length > maxLength.Value)
    {
      throw new InvalidOperationException($"The value for {maxLength.Value}-character field is too long.");
    }

    return normalized;
  }

  private static string NormalizeName(string value) => string.Join(' ', value.Trim().ToUpperInvariant().Split((char[]?)null, StringSplitOptions.RemoveEmptyEntries));

  private static string NormalizeHeader(string? value) => new string((value ?? string.Empty)
    .Where(char.IsLetterOrDigit)
    .Select(char.ToLowerInvariant)
    .ToArray());

  private static string? NormalizeCategory(string? value)
  {
    var normalized = NormalizeHeader(value);
    return normalized switch
    {
      "pep" or "politicallyexposedperson" => "PEP",
      "sanction" or "sanctions" or "sanctionlist" => "SANCTION",
      "watchlist" or "watch" => "WATCHLIST",
      "nberestricted" or "nberestrictedlist" => "NBE_RESTRICTED",
      "internalblacklist" or "blacklist" or "restricted" => "INTERNAL_BLACKLIST",
      _ => null
    };
  }

  private static string FormatHeader(string normalizedHeader) => normalizedHeader switch
  {
    "fullname" => "Full Name",
    "screeningcategory" => "Screening Category",
    "sourcelist" => "Source List",
    _ => normalizedHeader
  };

  private sealed record ParsedImportRow(int RowNumber, NormalizedWatchlistValues Values, string SourceDataJson);

  private sealed record NormalizedWatchlistValues(
    string FullName,
    string NormalizedName,
    string? AlternateNames,
    string ScreeningCategory,
    string SourceList,
    string? SourceReference,
    string? RiskLevel,
    string? Nationality,
    DateOnly? DateOfBirth,
    string? PlaceOfBirth,
    string? DocumentType,
    string? DocumentNumber,
    string? PositionOrRole,
    string? Organization,
    string? Country,
    string? CityOrRegion,
    string? Address,
    DateOnly? ListedOn,
    DateOnly? ExpiryDate,
    bool IsActive,
    bool IsPep,
    bool IsSanctioned,
    bool RequiresEnhancedDueDiligence,
    string? Remarks,
    string? SourceUrl
  );
}
