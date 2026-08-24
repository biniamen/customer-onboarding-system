using System.Data;
using System.Text;
using System.Text.Json;
using CustomerOnboarding.Backend.Data;
using CustomerOnboarding.Backend.Dtos;
using Oracle.ManagedDataAccess.Client;
using Oracle.ManagedDataAccess.Types;
using Microsoft.EntityFrameworkCore;

namespace CustomerOnboarding.Backend.Services;

public class ResourceMobilizationService(
  IConfiguration configuration,
  IEmployeeDirectoryService employeeDirectoryService,
  AppDbContext dbContext
) : IResourceMobilizationService
{
  private const string DepositMobColumnsSql = """
    SELECT COLUMN_NAME
    FROM ALL_TAB_COLUMNS
    WHERE OWNER = 'FCUBS145'
      AND TABLE_NAME = 'CVW_GBE_DEPOSIT_MOB'
    """;

  private const string AccountSnapshotSql = """
    SELECT CUSTNO, CUSTNAME, ACCLS
    FROM FCUBS145.CVW_IPS_CUST_ACCOUNT
    WHERE TRIM(ACC) = :accountNumber
       AND ROWNUM = 1
    """;

  private const string BranchNameSql = """
    SELECT BRANCH_NAME
    FROM FCUBS145.EVW_BRANCH_DATES
    WHERE TRIM(BRANCH_CODE) = :branchCode
      AND ROWNUM = 1
    """;

  private static readonly string[] ValueDateColumnCandidates =
  [
    "VALUE_DT",
    "VALUE_DATE",
    "VALUE_DTTM",
    "VAL_DT",
    "TRN_DT",
    "TXN_DATE",
    "TRN_DATE",
    "BOOK_DATE",
    "BOOK_DT"
  ];

  private readonly string _oracleConnectionString = configuration.GetConnectionString("OracleDb")
    ?? throw new InvalidOperationException("OracleDb connection string is not configured.");

  public async Task<IReadOnlyList<ResourceMobilizationEmployeeSearchResultDto>> SearchEmployeesAsync(string? search, int limit = 20, CancellationToken cancellationToken = default)
  {
    var employees = await employeeDirectoryService.SearchAsync(search, limit, cancellationToken);
    var profiles = await LoadRegistrationProfilesAsync(employees, cancellationToken);

    return employees
      .Select(employee =>
      {
        profiles.TryGetValue(employee.EmployeeId, out var profile);
        return MapEmployee(employee, profile);
      })
      .ToList();
  }

  public async Task<ResourceMobilizationEmployeeSearchResultDto?> GetEmployeeByIdAsync(string employeeDirectoryEntryId, CancellationToken cancellationToken = default)
  {
    var employee = await employeeDirectoryService.GetByIdAsync(employeeDirectoryEntryId, cancellationToken);
    if (employee is null)
    {
      return null;
    }

    RegistrationProfile? profile = null;
    if (!string.IsNullOrWhiteSpace(employee.EmployeeId))
    {
      profile = await dbContext.ResourceMobilizationRecords
        .AsNoTracking()
        .Where(x => x.EmployeeReference == employee.EmployeeId)
        .OrderByDescending(x => x.UpdatedAt)
        .ThenByDescending(x => x.CreatedAt)
        .Select(x => new RegistrationProfile(x.EmployeeReference, x.MonthlyTargetAmount, x.NewAccountCount))
        .FirstOrDefaultAsync(cancellationToken);
    }

    return MapEmployee(employee, profile);
  }

  public async Task<IReadOnlyList<ResourceMobilizationTransactionDto>> SearchTransactionsAsync(ResourceMobilizationTransactionLookupRequest request, CancellationToken cancellationToken = default)
  {
    var transactionReferenceNo = (request.TransactionReferenceNo ?? string.Empty).Trim();
    var accountNumber = (request.AccountNumber ?? string.Empty).Trim();
    var limit = Math.Clamp(request.Limit <= 0 ? 20 : request.Limit, 1, 50);

    if (string.IsNullOrWhiteSpace(transactionReferenceNo) &&
        string.IsNullOrWhiteSpace(accountNumber) &&
        !request.FromDate.HasValue &&
        !request.ToDate.HasValue)
    {
      return [];
    }

    await using var connection = new OracleConnection(_oracleConnectionString);
    await connection.OpenAsync(cancellationToken);

    var valueDateColumn = await ResolveValueDateColumnAsync(connection, cancellationToken);

    await using var command = BuildTransactionSearchCommand(
      connection,
      transactionReferenceNo,
      accountNumber,
      request.FromDate,
      request.ToDate,
      limit,
      valueDateColumn);

    await using var reader = await command.ExecuteReaderAsync(CommandBehavior.SequentialAccess, cancellationToken);

    var branchNameCache = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
    var accountSnapshotCache = new Dictionary<string, AccountSnapshot>(StringComparer.OrdinalIgnoreCase);
    var rows = new List<TransactionSearchRow>();

    while (await reader.ReadAsync(cancellationToken))
    {
      var trnRefNo = ReadString(reader, "TRN_REF_NO");
      var depositBranchCode = ReadString(reader, "AC_BRANCH");
      var depositAccountNumber = ReadString(reader, "AC_NO");
      var currency = ReadString(reader, "AC_CCY");
      var amount = ReadDecimal(reader, "LCY_AMOUNT");
      var valueDate = ReadDateTimeOffset(reader, valueDateColumn);

      if (string.IsNullOrWhiteSpace(trnRefNo) || string.IsNullOrWhiteSpace(depositAccountNumber))
      {
        continue;
      }

      var accountSnapshot = await GetAccountSnapshotAsync(connection, depositAccountNumber, accountSnapshotCache, cancellationToken);
      var branchName = await GetBranchNameAsync(connection, depositBranchCode, branchNameCache, cancellationToken);
      var suggestedProductType = SuggestDepositProductType(accountSnapshot?.AccountClass);
      var rawPayload = JsonSerializer.Serialize(new
      {
        TransactionReferenceNo = trnRefNo,
        DepositBranchCode = depositBranchCode,
        DepositBranchName = branchName,
        AccountNumber = depositAccountNumber,
        Currency = currency,
        Amount = amount,
        ValueDate = valueDate,
        CustomerNumber = accountSnapshot?.CustomerNumber,
        CustomerName = accountSnapshot?.CustomerName,
        AccountClass = accountSnapshot?.AccountClass,
        SuggestedProductType = suggestedProductType
      });

      rows.Add(new TransactionSearchRow(
        trnRefNo,
        depositBranchCode,
        branchName,
        depositAccountNumber,
        string.IsNullOrWhiteSpace(currency) ? "ETB" : currency,
        amount,
        valueDate,
        accountSnapshot?.CustomerNumber,
        accountSnapshot?.CustomerName ?? string.Empty,
        accountSnapshot?.AccountClass,
        suggestedProductType,
        rawPayload
      ));
    }

    if (rows.Count == 0)
    {
      return [];
    }

    var transactionReferences = rows
      .Select(x => x.TransactionReferenceNo)
      .Where(x => !string.IsNullOrWhiteSpace(x))
      .Distinct(StringComparer.OrdinalIgnoreCase)
      .ToList();

    var existingRecords = await dbContext.ResourceMobilizationRecords
      .AsNoTracking()
      .Where(x => transactionReferences.Contains(x.TransactionReferenceNo))
      .OrderByDescending(x => x.UpdatedAt)
      .ThenByDescending(x => x.CreatedAt)
      .Select(x => new ExistingRegistrationSnapshot(
        x.TransactionReferenceNo,
        x.Id,
        x.RegistrationReference,
        x.Status,
        x.EmployeeReference,
        x.EmployeeFullName))
      .ToListAsync(cancellationToken);

    var existingLookup = existingRecords
      .GroupBy(x => x.TransactionReferenceNo, StringComparer.OrdinalIgnoreCase)
      .ToDictionary(group => group.Key, group => group.First(), StringComparer.OrdinalIgnoreCase);

    return rows
      .Select(row =>
      {
        existingLookup.TryGetValue(row.TransactionReferenceNo, out var existing);
        return new ResourceMobilizationTransactionDto(
          row.TransactionReferenceNo,
          row.DepositBranchCode,
          row.DepositBranchName,
          row.AccountNumber,
          row.Currency,
          row.Amount,
          row.ValueDate,
          row.CustomerNumber,
          row.CustomerName,
          row.AccountClass,
          row.SuggestedProductType,
          row.RawPayload,
          existing is not null,
          existing?.ExistingRecordId,
          existing?.ExistingRegistrationReference,
          existing?.ExistingStatus,
          existing?.ExistingEmployeeReference,
          existing?.ExistingEmployeeFullName
        );
      })
      .ToList();
  }

  public async Task<ResourceMobilizationTransactionDto?> GetTransactionAsync(string transactionReferenceNo, string accountNumber, CancellationToken cancellationToken = default)
  {
    var results = await SearchTransactionsAsync(
      new ResourceMobilizationTransactionLookupRequest(transactionReferenceNo, accountNumber, null, null, 1),
      cancellationToken);

    return results.FirstOrDefault();
  }

  private async Task<Dictionary<string, RegistrationProfile>> LoadRegistrationProfilesAsync(
    IReadOnlyCollection<ExternalDirectoryUserDto> employees,
    CancellationToken cancellationToken)
  {
    var employeeReferences = employees
      .Select(x => x.EmployeeId)
      .Where(x => !string.IsNullOrWhiteSpace(x))
      .Distinct(StringComparer.OrdinalIgnoreCase)
      .ToList();

    if (employeeReferences.Count == 0)
    {
      return new Dictionary<string, RegistrationProfile>(StringComparer.OrdinalIgnoreCase);
    }

    var rows = await dbContext.ResourceMobilizationRecords
      .AsNoTracking()
      .Where(x => employeeReferences.Contains(x.EmployeeReference))
      .OrderByDescending(x => x.UpdatedAt)
      .ThenByDescending(x => x.CreatedAt)
      .Select(x => new RegistrationProfile(x.EmployeeReference, x.MonthlyTargetAmount, x.NewAccountCount))
      .ToListAsync(cancellationToken);

    return rows
      .GroupBy(x => x.EmployeeReference, StringComparer.OrdinalIgnoreCase)
      .ToDictionary(group => group.Key, group => group.First(), StringComparer.OrdinalIgnoreCase);
  }

  private async Task<string> ResolveValueDateColumnAsync(OracleConnection connection, CancellationToken cancellationToken)
  {
    await using var command = new OracleCommand(DepositMobColumnsSql, connection)
    {
      BindByName = true
    };

    await using var reader = await command.ExecuteReaderAsync(CommandBehavior.SequentialAccess, cancellationToken);
    var columns = new HashSet<string>(StringComparer.OrdinalIgnoreCase);

    while (await reader.ReadAsync(cancellationToken))
    {
      var columnName = ReadString(reader, "COLUMN_NAME");
      if (!string.IsNullOrWhiteSpace(columnName))
      {
        columns.Add(columnName);
      }
    }

    foreach (var candidate in ValueDateColumnCandidates)
    {
      if (columns.Contains(candidate))
      {
        return candidate;
      }
    }

    throw new InvalidOperationException(
      $"Unable to resolve the transaction value date column from FCUBS145.CVW_GBE_DEPOSIT_MOB. Available columns: {string.Join(", ", columns.OrderBy(x => x))}");
  }

  private static ResourceMobilizationEmployeeSearchResultDto MapEmployee(ExternalDirectoryUserDto employee, RegistrationProfile? profile)
  {
    return new ResourceMobilizationEmployeeSearchResultDto(
      employee.Id,
      employee.EmployeeId,
      employee.FullEmployeeName,
      employee.PhoneNumber,
      employee.BranchCode,
      employee.BranchName,
      employee.DepartmentName,
      employee.PositionName,
      employee.RoleName,
      employee.IsActive,
      profile is not null,
      profile?.MonthlyTargetAmount,
      profile?.NewAccountCount
    );
  }

  private static OracleCommand BuildTransactionSearchCommand(
    OracleConnection connection,
    string transactionReferenceNo,
    string accountNumber,
    DateTimeOffset? fromDate,
    DateTimeOffset? toDate,
    int limit,
    string valueDateColumn)
  {
    var sql = new StringBuilder(
      $"""
      SELECT *
      FROM (
        SELECT TRN_REF_NO, AC_BRANCH, AC_NO, AC_CCY, LCY_AMOUNT, {valueDateColumn}
        FROM FCUBS145.CVW_GBE_DEPOSIT_MOB
        WHERE 1 = 1
      """);

    var command = new OracleCommand
    {
      Connection = connection,
      BindByName = true
    };

    if (!string.IsNullOrWhiteSpace(transactionReferenceNo))
    {
      sql.AppendLine("  AND TRIM(TRN_REF_NO) = :transactionReferenceNo");
      command.Parameters.Add(new OracleParameter("transactionReferenceNo", OracleDbType.Varchar2, transactionReferenceNo, ParameterDirection.Input));
    }

    if (!string.IsNullOrWhiteSpace(accountNumber))
    {
      sql.AppendLine("  AND TRIM(AC_NO) = :accountNumber");
      command.Parameters.Add(new OracleParameter("accountNumber", OracleDbType.Varchar2, accountNumber, ParameterDirection.Input));
    }

    if (fromDate.HasValue)
    {
      sql.AppendLine($"  AND TRUNC({valueDateColumn}) >= :fromDate");
      command.Parameters.Add(new OracleParameter("fromDate", OracleDbType.Date, fromDate.Value.Date, ParameterDirection.Input));
    }

    if (toDate.HasValue)
    {
      sql.AppendLine($"  AND TRUNC({valueDateColumn}) <= :toDate");
      command.Parameters.Add(new OracleParameter("toDate", OracleDbType.Date, toDate.Value.Date, ParameterDirection.Input));
    }

    sql.AppendLine($"  ORDER BY {valueDateColumn} DESC, TRN_REF_NO DESC");
    sql.AppendLine(")");
    sql.AppendLine("WHERE ROWNUM <= :maxRows");

    command.Parameters.Add(new OracleParameter("maxRows", OracleDbType.Int32, limit, ParameterDirection.Input));
    command.CommandText = sql.ToString();
    return command;
  }

  private static async Task<AccountSnapshot?> GetAccountSnapshotAsync(
    OracleConnection connection,
    string accountNumber,
    IDictionary<string, AccountSnapshot> cache,
    CancellationToken cancellationToken)
  {
    if (cache.TryGetValue(accountNumber, out var cached))
    {
      return cached;
    }

    await using var command = new OracleCommand(AccountSnapshotSql, connection)
    {
      BindByName = true
    };
    command.Parameters.Add(new OracleParameter("accountNumber", OracleDbType.Varchar2, accountNumber, ParameterDirection.Input));
    await using var reader = await command.ExecuteReaderAsync(CommandBehavior.SequentialAccess, cancellationToken);

    if (!await reader.ReadAsync(cancellationToken))
    {
      return null;
    }

    var snapshot = new AccountSnapshot(
      ReadString(reader, "CUSTNO"),
      ReadString(reader, "CUSTNAME"),
      ReadString(reader, "ACCLS")
    );

    cache[accountNumber] = snapshot;
    return snapshot;
  }

  private static async Task<string> GetBranchNameAsync(
    OracleConnection connection,
    string branchCode,
    IDictionary<string, string> cache,
    CancellationToken cancellationToken)
  {
    if (string.IsNullOrWhiteSpace(branchCode))
    {
      return string.Empty;
    }

    if (cache.TryGetValue(branchCode, out var cached))
    {
      return cached;
    }

    await using var command = new OracleCommand(BranchNameSql, connection)
    {
      BindByName = true
    };
    command.Parameters.Add(new OracleParameter("branchCode", OracleDbType.Varchar2, branchCode.Trim(), ParameterDirection.Input));

    var result = await command.ExecuteScalarAsync(cancellationToken);
    var branchName = result?.ToString()?.Trim() ?? string.Empty;
    cache[branchCode] = branchName;
    return branchName;
  }

  private static string ReadString(IDataRecord reader, string columnName)
  {
    var ordinal = reader.GetOrdinal(columnName);
    if (reader.IsDBNull(ordinal))
    {
      return string.Empty;
    }

    return reader.GetValue(ordinal)?.ToString()?.Trim() ?? string.Empty;
  }

  private static decimal ReadDecimal(IDataRecord reader, string columnName)
  {
    var ordinal = reader.GetOrdinal(columnName);
    if (reader.IsDBNull(ordinal))
    {
      return 0m;
    }

    var rawValue = reader.GetValue(ordinal);
    return rawValue switch
    {
      decimal decimalValue => decimalValue,
      OracleDecimal oracleDecimal => oracleDecimal.Value,
      _ when decimal.TryParse(rawValue?.ToString(), out var parsed) => parsed,
      _ => 0m
    };
  }

  private static DateTimeOffset ReadDateTimeOffset(IDataRecord reader, string columnName)
  {
    var ordinal = reader.GetOrdinal(columnName);
    if (reader.IsDBNull(ordinal))
    {
      return DateTimeOffset.UtcNow;
    }

    var rawValue = reader.GetValue(ordinal);
    var date = rawValue switch
    {
      DateTime dateTime => dateTime,
      OracleDate oracleDate => oracleDate.Value,
      _ when DateTime.TryParse(rawValue?.ToString(), out var parsed) => parsed,
      _ => DateTime.UtcNow
    };

    var offset = TimeSpan.FromHours(3);
    return new DateTimeOffset(date.Year, date.Month, date.Day, date.Hour, date.Minute, date.Second, offset);
  }

  private static string SuggestDepositProductType(string? accountClass)
  {
    var value = (accountClass ?? string.Empty).Trim().ToUpperInvariant();
    if (string.IsNullOrWhiteSpace(value))
    {
      return "SAVING";
    }

    if (value.StartsWith("C", StringComparison.OrdinalIgnoreCase))
    {
      return "DEMAND";
    }

    if (value.StartsWith("W", StringComparison.OrdinalIgnoreCase) ||
        value.StartsWith("HJ", StringComparison.OrdinalIgnoreCase) ||
        value.EndsWith("US", StringComparison.OrdinalIgnoreCase))
    {
      return "IFB";
    }

    return "SAVING";
  }

  private sealed record AccountSnapshot(
    string CustomerNumber,
    string CustomerName,
    string AccountClass
  );

  private sealed record TransactionSearchRow(
    string TransactionReferenceNo,
    string DepositBranchCode,
    string DepositBranchName,
    string AccountNumber,
    string Currency,
    decimal Amount,
    DateTimeOffset ValueDate,
    string? CustomerNumber,
    string CustomerName,
    string? AccountClass,
    string SuggestedProductType,
    string RawPayload
  );

  private sealed record ExistingRegistrationSnapshot(
    string TransactionReferenceNo,
    int ExistingRecordId,
    string ExistingRegistrationReference,
    string ExistingStatus,
    string ExistingEmployeeReference,
    string ExistingEmployeeFullName
  );

  private sealed record RegistrationProfile(
    string EmployeeReference,
    decimal MonthlyTargetAmount,
    int NewAccountCount
  );
}
