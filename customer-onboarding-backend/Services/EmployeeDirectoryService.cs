using System.Globalization;
using System.IO.Compression;
using System.Text.RegularExpressions;
using System.Xml.Linq;
using CustomerOnboarding.Backend.Data;
using CustomerOnboarding.Backend.Dtos;
using CustomerOnboarding.Backend.Models;
using Microsoft.EntityFrameworkCore;

namespace CustomerOnboarding.Backend.Services;

public class EmployeeDirectoryService(AppDbContext dbContext) : IEmployeeDirectoryService
{
  private static readonly HashSet<string> ImportedColumns =
  [
    "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N"
  ];

  public async Task<IReadOnlyList<ExternalDirectoryUserDto>> SearchAsync(string? search, int limit = 20, CancellationToken cancellationToken = default)
  {
    var keyword = (search ?? string.Empty).Trim();
    if (keyword.Length < 2)
    {
      return [];
    }

    var cappedLimit = Math.Clamp(limit, 5, 50);
    var normalizedPhone = NormalizePhoneNumber(keyword);

    var query = dbContext.EmployeeDirectoryEntries
      .AsNoTracking()
      .Where(x => x.IsActive)
      .Where(x =>
        EF.Functions.ILike(x.EmployeeReference, $"%{keyword}%") ||
        EF.Functions.ILike(x.FullName, $"%{keyword}%") ||
        EF.Functions.ILike(x.PhoneNumber, $"%{keyword}%") ||
        (!string.IsNullOrWhiteSpace(normalizedPhone) && EF.Functions.ILike(x.PhoneNumberNormalized, $"%{normalizedPhone}%")) ||
        EF.Functions.ILike(x.AssignedUnitName, $"%{keyword}%") ||
        EF.Functions.ILike(x.BranchCode, $"%{keyword}%") ||
        EF.Functions.ILike(x.CurrentPosition, $"%{keyword}%") ||
        EF.Functions.ILike(x.Classification, $"%{keyword}%")
      )
      .OrderByDescending(x => x.EmployeeReference == keyword)
      .ThenByDescending(x => x.PhoneNumberNormalized == normalizedPhone)
      .ThenByDescending(x => EF.Functions.ILike(x.FullName, $"{keyword}%"))
      .ThenByDescending(x => EF.Functions.ILike(x.AssignedUnitName, $"{keyword}%"))
      .ThenBy(x => x.FullName)
      .ThenBy(x => x.EmployeeReference)
      .Take(cappedLimit);

    var employees = await query.ToListAsync(cancellationToken);
    return employees.Select(MapToDto).ToList();
  }

  public async Task<ExternalDirectoryUserDto?> GetByIdAsync(string employeeDirectoryId, CancellationToken cancellationToken = default)
  {
    if (!Guid.TryParse(employeeDirectoryId, out var employeeId))
    {
      return null;
    }

    var employee = await dbContext.EmployeeDirectoryEntries
      .AsNoTracking()
      .FirstOrDefaultAsync(x => x.Id == employeeId, cancellationToken);

    return employee is null ? null : MapToDto(employee);
  }

  public async Task<EmployeeDirectoryPagedResponseDto> GetPagedAsync(EmployeeDirectoryQueryDto query, CancellationToken cancellationToken = default)
  {
    var keyword = (query.Search ?? string.Empty).Trim();
    var normalizedPhone = NormalizePhoneNumber(keyword);
    var branchCode = (query.BranchCode ?? string.Empty).Trim();

    var employees = dbContext.EmployeeDirectoryEntries
      .AsNoTracking()
      .AsQueryable();

    if (!string.IsNullOrWhiteSpace(keyword))
    {
      employees = employees.Where(x =>
        EF.Functions.ILike(x.EmployeeReference, $"%{keyword}%") ||
        EF.Functions.ILike(x.FullName, $"%{keyword}%") ||
        EF.Functions.ILike(x.PhoneNumber, $"%{keyword}%") ||
        (!string.IsNullOrWhiteSpace(normalizedPhone) && EF.Functions.ILike(x.PhoneNumberNormalized, $"%{normalizedPhone}%")) ||
        EF.Functions.ILike(x.AssignedUnitName, $"%{keyword}%") ||
        EF.Functions.ILike(x.BranchCode, $"%{keyword}%") ||
        EF.Functions.ILike(x.CurrentPosition, $"%{keyword}%") ||
        EF.Functions.ILike(x.Classification, $"%{keyword}%"));
    }

    if (!string.IsNullOrWhiteSpace(branchCode))
    {
      employees = employees.Where(x => x.BranchCode == branchCode);
    }

    if (query.IsActive.HasValue)
    {
      employees = employees.Where(x => x.IsActive == query.IsActive.Value);
    }

    employees = employees
      .OrderByDescending(x => x.IsActive)
      .ThenBy(x => x.FullName)
      .ThenBy(x => x.EmployeeReference);

    var totalRecords = await employees.CountAsync(cancellationToken);
    var pageSize = query.PageSize == -1 ? int.MaxValue : (query.PageSize <= 0 ? 20 : query.PageSize);
    var page = query.Page <= 0 ? 1 : query.Page;

    List<EmployeeDirectoryEntry> rows;
    var totalPages = 1;

    if (pageSize == int.MaxValue)
    {
      rows = await employees.ToListAsync(cancellationToken);
      page = 1;
    }
    else
    {
      totalPages = Math.Max(1, (int)Math.Ceiling(totalRecords / (double)pageSize));
      page = Math.Min(page, totalPages);
      var skip = (page - 1) * pageSize;
      rows = await employees.Skip(skip).Take(pageSize).ToListAsync(cancellationToken);
    }

    return new EmployeeDirectoryPagedResponseDto(
      page,
      pageSize,
      totalRecords,
      totalPages,
      rows.Select(MapToListItemDto).ToList()
    );
  }

  public async Task<EmployeeDirectoryListItemDto?> GetEntryByIdAsync(string employeeDirectoryId, CancellationToken cancellationToken = default)
  {
    if (!Guid.TryParse(employeeDirectoryId, out var employeeId))
    {
      return null;
    }

    var employee = await dbContext.EmployeeDirectoryEntries
      .AsNoTracking()
      .FirstOrDefaultAsync(x => x.Id == employeeId, cancellationToken);

    return employee is null ? null : MapToListItemDto(employee);
  }

  public async Task<EmployeeDirectoryListItemDto?> UpdateAsync(string employeeDirectoryId, UpdateEmployeeDirectoryEntryRequest request, CancellationToken cancellationToken = default)
  {
    if (!Guid.TryParse(employeeDirectoryId, out var employeeId))
    {
      return null;
    }

    var employee = await dbContext.EmployeeDirectoryEntries.FirstOrDefaultAsync(x => x.Id == employeeId, cancellationToken);
    if (employee is null)
    {
      return null;
    }

    var employeeReference = Fit(request.EmployeeReference, 96);
    if (string.IsNullOrWhiteSpace(employeeReference))
    {
      throw new InvalidOperationException("Employee reference is required.");
    }

    var existingReference = await dbContext.EmployeeDirectoryEntries
      .AsNoTracking()
      .AnyAsync(x => x.Id != employee.Id && x.EmployeeReference == employeeReference, cancellationToken);
    if (existingReference)
    {
      throw new InvalidOperationException("Employee reference already exists.");
    }

    employee.SequenceNumber = request.SequenceNumber;
    employee.EmployeeReference = employeeReference;
    employee.EmployeeCode = Fit(request.EmployeeCode, 32);
    employee.InternalNumber = Fit(request.InternalNumber, 32);
    employee.InternalNumberExtension = Fit(request.InternalNumberExtension, 32);
    employee.FirstName = Fit(request.FirstName, 80);
    employee.MiddleName = Fit(request.MiddleName, 120);
    employee.LastName = Fit(request.LastName, 80);
    employee.FullName = Fit(
      string.IsNullOrWhiteSpace(request.FullEmployeeName)
        ? ComposeFullName(request.FirstName, request.MiddleName, request.LastName)
        : request.FullEmployeeName,
      220);
    employee.Gender = Fit(request.Gender, 16);
    employee.ContactAddress = Fit(request.ContactAddress, 120);
    employee.PhoneNumber = Fit(request.PhoneNumber, 32);
    employee.PhoneNumberNormalized = NormalizePhoneNumber(request.PhoneNumber);
    employee.CurrentPosition = Fit(request.CurrentPosition, 220);
    employee.Classification = Fit(request.Classification, 80);
    employee.AssignedUnitName = Fit(request.AssignedUnitName, 220);
    employee.BranchGrade = Fit(request.BranchGrade, 80);
    employee.BranchCode = Fit(request.BranchCode, 32);
    employee.District = Fit(request.District, 80);
    employee.EmploymentDate = request.EmploymentDate;
    employee.IsActive = request.IsActive;
    employee.UpdatedAtUtc = DateTimeOffset.UtcNow;

    await dbContext.SaveChangesAsync(cancellationToken);
    return MapToListItemDto(employee);
  }

  public async Task<bool> DeleteAsync(string employeeDirectoryId, CancellationToken cancellationToken = default)
  {
    if (!Guid.TryParse(employeeDirectoryId, out var employeeId))
    {
      return false;
    }

    var employee = await dbContext.EmployeeDirectoryEntries.FirstOrDefaultAsync(x => x.Id == employeeId, cancellationToken);
    if (employee is null)
    {
      return false;
    }

    dbContext.EmployeeDirectoryEntries.Remove(employee);
    await dbContext.SaveChangesAsync(cancellationToken);
    return true;
  }

  public async Task<EmployeeDirectoryStatsDto> GetStatsAsync(CancellationToken cancellationToken = default)
  {
    var totalEmployees = await dbContext.EmployeeDirectoryEntries.CountAsync(cancellationToken);
    var activeEmployees = await dbContext.EmployeeDirectoryEntries.CountAsync(x => x.IsActive, cancellationToken);
    var latestImport = await dbContext.EmployeeDirectoryEntries
      .AsNoTracking()
      .OrderByDescending(x => x.ImportedAtUtc)
      .Select(x => new { x.ImportedAtUtc, x.SourceFileName })
      .FirstOrDefaultAsync(cancellationToken);

    return new EmployeeDirectoryStatsDto(
      totalEmployees,
      activeEmployees,
      latestImport?.ImportedAtUtc,
      latestImport?.SourceFileName
    );
  }

  public async Task<EmployeeDirectoryImportResultDto> ImportAsync(Stream workbookStream, string sourceFileName, string importedByUserName, CancellationToken cancellationToken = default)
  {
    var importedAtUtc = DateTimeOffset.UtcNow;
    var parsedWorkbook = ParseWorkbook(workbookStream, sourceFileName, importedAtUtc);
    if (parsedWorkbook.Entries.Count == 0)
    {
      throw new InvalidOperationException("No employee rows were found in the uploaded workbook.");
    }

    var employeeReferences = parsedWorkbook.Entries
      .Select(x => x.EmployeeReference)
      .Where(x => !string.IsNullOrWhiteSpace(x))
      .Distinct(StringComparer.OrdinalIgnoreCase)
      .ToList();

    var existingEmployees = await dbContext.EmployeeDirectoryEntries
      .Where(x => employeeReferences.Contains(x.EmployeeReference))
      .ToDictionaryAsync(x => x.EmployeeReference, StringComparer.OrdinalIgnoreCase, cancellationToken);

    var insertedRows = 0;
    var updatedRows = 0;

    foreach (var importedEmployee in parsedWorkbook.Entries)
    {
      if (existingEmployees.TryGetValue(importedEmployee.EmployeeReference, out var existingEmployee))
      {
        ApplyImportedValues(existingEmployee, importedEmployee, importedAtUtc);
        updatedRows += 1;
      }
      else
      {
        dbContext.EmployeeDirectoryEntries.Add(importedEmployee);
        insertedRows += 1;
      }
    }

    var existingActiveEmployees = await dbContext.EmployeeDirectoryEntries
      .Where(x => x.IsActive)
      .ToListAsync(cancellationToken);

    var activeReferenceSet = employeeReferences.ToHashSet(StringComparer.OrdinalIgnoreCase);
    var deactivatedRows = 0;
    foreach (var staleEmployee in existingActiveEmployees.Where(x => !activeReferenceSet.Contains(x.EmployeeReference)))
    {
      staleEmployee.IsActive = false;
      staleEmployee.UpdatedAtUtc = importedAtUtc;
      staleEmployee.SourceFileName = string.IsNullOrWhiteSpace(staleEmployee.SourceFileName) ? sourceFileName : staleEmployee.SourceFileName;
      staleEmployee.SourceSheetName = string.IsNullOrWhiteSpace(staleEmployee.SourceSheetName) ? parsedWorkbook.SheetName : staleEmployee.SourceSheetName;
      deactivatedRows += 1;
    }

    await dbContext.SaveChangesAsync(cancellationToken);

    var totalActiveEmployees = await dbContext.EmployeeDirectoryEntries.CountAsync(x => x.IsActive, cancellationToken);
    return new EmployeeDirectoryImportResultDto(
      Path.GetFileName(sourceFileName),
      parsedWorkbook.SheetName,
      parsedWorkbook.Entries.Count,
      insertedRows,
      updatedRows,
      deactivatedRows,
      totalActiveEmployees,
      importedAtUtc
    );
  }

  private static ParsedWorkbook ParseWorkbook(Stream workbookStream, string sourceFileName, DateTimeOffset importedAtUtc)
  {
    using var memoryStream = new MemoryStream();
    workbookStream.CopyTo(memoryStream);
    memoryStream.Position = 0;

    using var archive = new ZipArchive(memoryStream, ZipArchiveMode.Read, leaveOpen: false);
    var workbookDocument = LoadXmlDocument(archive, "xl/workbook.xml")
      ?? throw new InvalidOperationException("Workbook metadata could not be read from the uploaded Excel file.");
    var workbookRelationships = LoadXmlDocument(archive, "xl/_rels/workbook.xml.rels")
      ?? throw new InvalidOperationException("Workbook relationships could not be read from the uploaded Excel file.");

    XNamespace spreadsheetNamespace = "http://schemas.openxmlformats.org/spreadsheetml/2006/main";
    XNamespace relationshipNamespace = "http://schemas.openxmlformats.org/officeDocument/2006/relationships";
    XNamespace packageRelationshipNamespace = "http://schemas.openxmlformats.org/package/2006/relationships";

    var firstSheet = workbookDocument
      .Root?
      .Element(spreadsheetNamespace + "sheets")?
      .Elements(spreadsheetNamespace + "sheet")
      .FirstOrDefault()
      ?? throw new InvalidOperationException("No worksheet was found in the uploaded Excel file.");

    var relationshipId = firstSheet.Attribute(relationshipNamespace + "id")?.Value;
    if (string.IsNullOrWhiteSpace(relationshipId))
    {
      throw new InvalidOperationException("The uploaded Excel file does not contain a valid worksheet relationship.");
    }

    var targetWorksheet = workbookRelationships
      .Root?
      .Elements(packageRelationshipNamespace + "Relationship")
      .FirstOrDefault(x => string.Equals(x.Attribute("Id")?.Value, relationshipId, StringComparison.OrdinalIgnoreCase))
      ?.Attribute("Target")?.Value;

    if (string.IsNullOrWhiteSpace(targetWorksheet))
    {
      throw new InvalidOperationException("The uploaded Excel file does not point to a readable worksheet.");
    }

    var worksheetPath = targetWorksheet.StartsWith("xl/", StringComparison.OrdinalIgnoreCase)
      ? targetWorksheet
      : $"xl/{targetWorksheet.TrimStart('/')}";

    var worksheetDocument = LoadXmlDocument(archive, worksheetPath)
      ?? throw new InvalidOperationException("The employee worksheet could not be read from the uploaded Excel file.");
    var sharedStrings = LoadSharedStrings(archive);
    var sheetName = firstSheet.Attribute("name")?.Value ?? "Sheet1";

    var rows = worksheetDocument
      .Root?
      .Element(spreadsheetNamespace + "sheetData")?
      .Elements(spreadsheetNamespace + "row")
      .ToList()
      ?? [];

    if (rows.Count <= 1)
    {
      throw new InvalidOperationException("The uploaded Excel file does not contain employee rows.");
    }

    var entries = new List<EmployeeDirectoryEntry>();
    foreach (var row in rows.Skip(1))
    {
      var parsedRow = ParseRow(row, spreadsheetNamespace, sharedStrings, sourceFileName, sheetName, importedAtUtc);
      if (parsedRow is not null)
      {
        entries.Add(parsedRow);
      }
    }

    return new ParsedWorkbook(sheetName, entries);
  }

  private static EmployeeDirectoryEntry? ParseRow(XElement row, XNamespace spreadsheetNamespace, IReadOnlyList<string> sharedStrings, string sourceFileName, string sourceSheetName, DateTimeOffset importedAtUtc)
  {
    var valuesByColumn = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
    foreach (var cell in row.Elements(spreadsheetNamespace + "c"))
    {
      var cellReference = cell.Attribute("r")?.Value ?? string.Empty;
      var columnName = GetColumnName(cellReference);
      if (string.IsNullOrWhiteSpace(columnName) || !ImportedColumns.Contains(columnName))
      {
        continue;
      }

      var cellValue = GetCellValue(cell, spreadsheetNamespace, sharedStrings).Trim();
      if (!string.IsNullOrWhiteSpace(cellValue))
      {
        valuesByColumn[columnName] = cellValue;
      }
    }

    var fullName = GetValue(valuesByColumn, "B");
    if (string.IsNullOrWhiteSpace(fullName))
    {
      return null;
    }

    var employeeCode = GetValue(valuesByColumn, "C");
    var internalNumber = GetValue(valuesByColumn, "D");
    var internalNumberExtension = GetValue(valuesByColumn, "E");
    var employeeReference = $"{employeeCode}{internalNumber}{internalNumberExtension}".Trim();
    if (string.IsNullOrWhiteSpace(employeeReference))
    {
      return null;
    }

    SplitName(fullName, out var firstName, out var middleName, out var lastName);
    var contactAddress = GetValue(valuesByColumn, "G");
    var phoneNumber = contactAddress;

    return new EmployeeDirectoryEntry
    {
      SourceRowNumber = int.TryParse(row.Attribute("r")?.Value, out var sourceRowNumber) ? sourceRowNumber : 0,
      SequenceNumber = int.TryParse(GetValue(valuesByColumn, "A"), out var sequenceNumber) ? sequenceNumber : null,
      FullName = fullName,
      FirstName = firstName,
      MiddleName = middleName,
      LastName = lastName,
      EmployeeCode = employeeCode,
      InternalNumber = internalNumber,
      InternalNumberExtension = internalNumberExtension,
      EmployeeReference = employeeReference,
      Gender = GetValue(valuesByColumn, "F"),
      ContactAddress = contactAddress,
      PhoneNumber = phoneNumber,
      PhoneNumberNormalized = NormalizePhoneNumber(phoneNumber),
      CurrentPosition = GetValue(valuesByColumn, "H"),
      Classification = GetValue(valuesByColumn, "I"),
      AssignedUnitName = GetValue(valuesByColumn, "J"),
      BranchGrade = GetValue(valuesByColumn, "K"),
      BranchCode = GetValue(valuesByColumn, "L"),
      District = GetValue(valuesByColumn, "M"),
      EmploymentDate = ParseEmploymentDate(GetValue(valuesByColumn, "N")),
      IsActive = true,
      SourceFileName = Path.GetFileName(sourceFileName),
      SourceSheetName = sourceSheetName,
      ImportedAtUtc = importedAtUtc,
      UpdatedAtUtc = importedAtUtc
    };
  }

  private static void ApplyImportedValues(EmployeeDirectoryEntry target, EmployeeDirectoryEntry source, DateTimeOffset importedAtUtc)
  {
    target.SourceRowNumber = source.SourceRowNumber;
    target.SequenceNumber = source.SequenceNumber;
    target.FullName = source.FullName;
    target.FirstName = source.FirstName;
    target.MiddleName = source.MiddleName;
    target.LastName = source.LastName;
    target.EmployeeCode = source.EmployeeCode;
    target.InternalNumber = source.InternalNumber;
    target.InternalNumberExtension = source.InternalNumberExtension;
    target.EmployeeReference = source.EmployeeReference;
    target.Gender = source.Gender;
    target.ContactAddress = source.ContactAddress;
    target.PhoneNumber = source.PhoneNumber;
    target.PhoneNumberNormalized = source.PhoneNumberNormalized;
    target.CurrentPosition = source.CurrentPosition;
    target.Classification = source.Classification;
    target.AssignedUnitName = source.AssignedUnitName;
    target.BranchGrade = source.BranchGrade;
    target.BranchCode = source.BranchCode;
    target.District = source.District;
    target.EmploymentDate = source.EmploymentDate;
    target.IsActive = true;
    target.SourceFileName = source.SourceFileName;
    target.SourceSheetName = source.SourceSheetName;
    target.ImportedAtUtc = importedAtUtc;
    target.UpdatedAtUtc = importedAtUtc;
  }

  private static XDocument? LoadXmlDocument(ZipArchive archive, string entryPath)
  {
    var entry = archive.GetEntry(entryPath);
    if (entry is null)
    {
      return null;
    }

    using var stream = entry.Open();
    return XDocument.Load(stream);
  }

  private static List<string> LoadSharedStrings(ZipArchive archive)
  {
    var sharedStringDocument = LoadXmlDocument(archive, "xl/sharedStrings.xml");
    if (sharedStringDocument?.Root is null)
    {
      return [];
    }

    XNamespace spreadsheetNamespace = "http://schemas.openxmlformats.org/spreadsheetml/2006/main";
    return sharedStringDocument.Root
      .Elements(spreadsheetNamespace + "si")
      .Select(si => string.Concat(si.Descendants(spreadsheetNamespace + "t").Select(textNode => textNode.Value)))
      .ToList();
  }

  private static string GetCellValue(XElement cell, XNamespace spreadsheetNamespace, IReadOnlyList<string> sharedStrings)
  {
    var cellType = cell.Attribute("t")?.Value ?? string.Empty;
    if (string.Equals(cellType, "inlineStr", StringComparison.OrdinalIgnoreCase))
    {
      return string.Concat(cell.Descendants(spreadsheetNamespace + "t").Select(textNode => textNode.Value));
    }

    var rawValue = cell.Element(spreadsheetNamespace + "v")?.Value ?? string.Empty;
    if (string.Equals(cellType, "s", StringComparison.OrdinalIgnoreCase) &&
        int.TryParse(rawValue, out var sharedStringIndex) &&
        sharedStringIndex >= 0 &&
        sharedStringIndex < sharedStrings.Count)
    {
      return sharedStrings[sharedStringIndex];
    }

    return rawValue;
  }

  private static string GetColumnName(string cellReference)
  {
    if (string.IsNullOrWhiteSpace(cellReference))
    {
      return string.Empty;
    }

    return string.Concat(cellReference.TakeWhile(char.IsLetter));
  }

  private static string GetValue(IReadOnlyDictionary<string, string> valuesByColumn, string columnName)
  {
    return valuesByColumn.TryGetValue(columnName, out var value)
      ? value.Trim()
      : string.Empty;
  }

  private static void SplitName(string fullName, out string firstName, out string middleName, out string lastName)
  {
    var parts = fullName
      .Split(' ', StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries);

    if (parts.Length == 0)
    {
      firstName = string.Empty;
      middleName = string.Empty;
      lastName = string.Empty;
      return;
    }

    if (parts.Length == 1)
    {
      firstName = parts[0];
      middleName = string.Empty;
      lastName = string.Empty;
      return;
    }

    if (parts.Length == 2)
    {
      firstName = parts[0];
      middleName = string.Empty;
      lastName = parts[1];
      return;
    }

    firstName = parts[0];
    lastName = parts[^1];
    middleName = string.Join(' ', parts.Skip(1).Take(parts.Length - 2));
  }

  private static DateOnly? ParseEmploymentDate(string rawValue)
  {
    if (string.IsNullOrWhiteSpace(rawValue))
    {
      return null;
    }

    if (double.TryParse(rawValue, NumberStyles.Float, CultureInfo.InvariantCulture, out var excelSerialDate))
    {
      var date = DateTime.FromOADate(excelSerialDate);
      return DateOnly.FromDateTime(date);
    }

    if (DateTime.TryParse(rawValue, CultureInfo.InvariantCulture, DateTimeStyles.None, out var parsedDate))
    {
      return DateOnly.FromDateTime(parsedDate);
    }

    return null;
  }

  private static string NormalizePhoneNumber(string rawPhoneNumber)
  {
    var digits = string.Concat((rawPhoneNumber ?? string.Empty).Where(char.IsDigit));
    if (string.IsNullOrWhiteSpace(digits))
    {
      return string.Empty;
    }

    if (digits.StartsWith("251", StringComparison.Ordinal) && digits.Length > 3)
    {
      return $"0{digits[3..]}";
    }

    if (digits.Length == 9)
    {
      return $"0{digits}";
    }

    return digits;
  }

  private static ExternalDirectoryUserDto MapToDto(EmployeeDirectoryEntry employee)
  {
    return new ExternalDirectoryUserDto(
      employee.Id.ToString(),
      employee.EmployeeReference,
      employee.FirstName,
      employee.MiddleName,
      employee.LastName,
      employee.FullName,
      employee.Gender,
      string.Empty,
      employee.PhoneNumber,
      employee.IsActive,
      null,
      employee.AssignedUnitName,
      employee.BranchCode,
      null,
      employee.AssignedUnitName,
      null,
      employee.Classification,
      null,
      employee.CurrentPosition,
      false,
      null,
      null,
      employee.ImportedAtUtc,
      employee.UpdatedAtUtc
    );
  }

  private static EmployeeDirectoryListItemDto MapToListItemDto(EmployeeDirectoryEntry employee)
  {
    return new EmployeeDirectoryListItemDto(
      employee.Id.ToString(),
      employee.SequenceNumber,
      employee.EmployeeReference,
      employee.EmployeeCode,
      employee.InternalNumber,
      employee.InternalNumberExtension,
      employee.FirstName,
      employee.MiddleName,
      employee.LastName,
      employee.FullName,
      employee.Gender,
      employee.ContactAddress,
      employee.PhoneNumber,
      employee.CurrentPosition,
      employee.Classification,
      employee.AssignedUnitName,
      employee.BranchGrade,
      employee.BranchCode,
      employee.District,
      employee.EmploymentDate,
      employee.IsActive,
      employee.SourceFileName,
      employee.SourceSheetName,
      employee.ImportedAtUtc,
      employee.UpdatedAtUtc
    );
  }

  private static string ComposeFullName(string? firstName, string? middleName, string? lastName)
  {
    return string.Join(' ', new[] { firstName, middleName, lastName }
      .Where(value => !string.IsNullOrWhiteSpace(value))
      .Select(value => value!.Trim()));
  }

  private static string Fit(string? value, int maxLength)
  {
    var normalized = (value ?? string.Empty).Trim();
    return normalized.Length <= maxLength ? normalized : normalized[..maxLength];
  }

  private sealed record ParsedWorkbook(string SheetName, List<EmployeeDirectoryEntry> Entries);
}
