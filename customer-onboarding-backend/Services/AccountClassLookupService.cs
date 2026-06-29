using System.Data;
using System.Data.Common;
using CustomerOnboarding.Backend.Dtos;
using Oracle.ManagedDataAccess.Client;

namespace CustomerOnboarding.Backend.Services;

public class AccountClassLookupService(IConfiguration configuration) : IAccountClassLookupService
{
  private const string AccountClassesSql = """
    SELECT ACCOUNT_CLASS, DESCRIPTION, ACCOUNT_CODE
    FROM FCUBS145.STTM_ACCOUNT_CLASS
    WHERE ACCOUNT_CLASS IS NOT NULL
    ORDER BY ACCOUNT_CLASS
    """;

  private const string MinimumBalancesSql = """
    SELECT ACCOUNT_CLASS, CCY_CODE, DFLT_MIN_BAL, DFLT_MIN_OPEN_BAL
    FROM FCUBS145.STTM_ACCLS_MIN_BAL
    WHERE CCY_CODE = :currencyCode
    """;

  private readonly string _oracleConnectionString = configuration.GetConnectionString("OracleDb")
    ?? throw new InvalidOperationException("OracleDb connection string is not configured.");

  public async Task<IReadOnlyList<AccountClassOptionDto>> GetAccountClassesAsync(CancellationToken cancellationToken = default)
  {
    var minimumBalanceByClass = new Dictionary<string, (decimal MinimumOpeningBalance, string CurrencyCode)>(StringComparer.OrdinalIgnoreCase);
    await using var connection = new OracleConnection(_oracleConnectionString);
    await connection.OpenAsync(cancellationToken);

    await LoadMinimumBalancesAsync(connection, minimumBalanceByClass, cancellationToken);

    var accountClasses = new List<AccountClassOptionDto>();
    await using var command = new OracleCommand(AccountClassesSql, connection)
    {
      BindByName = true
    };

    await using var reader = await command.ExecuteReaderAsync(CommandBehavior.SequentialAccess, cancellationToken);
    var ordinals = GetOrdinals(reader);
    while (await reader.ReadAsync(cancellationToken))
    {
      var code = ReadString(reader, ordinals, "ACCOUNT_CLASS");
      if (string.IsNullOrWhiteSpace(code))
      {
        continue;
      }

      var name = ReadString(reader, ordinals, "DESCRIPTION");
      var accountCode = ReadString(reader, ordinals, "ACCOUNT_CODE");
      var minimumBalance = minimumBalanceByClass.TryGetValue(code, out var balanceConfig)
        ? balanceConfig
        : (MinimumOpeningBalance: 0m, CurrencyCode: "ETB");

      accountClasses.Add(new AccountClassOptionDto(
        code,
        name,
        accountCode,
        minimumBalance.MinimumOpeningBalance,
        minimumBalance.CurrencyCode
      ));
    }

    return accountClasses;
  }

  private static async Task LoadMinimumBalancesAsync(
    OracleConnection connection,
    IDictionary<string, (decimal MinimumOpeningBalance, string CurrencyCode)> minimumBalanceByClass,
    CancellationToken cancellationToken)
  {
    await using var command = new OracleCommand(MinimumBalancesSql, connection)
    {
      BindByName = true
    };
    command.Parameters.Add(new OracleParameter("currencyCode", OracleDbType.Varchar2, "ETB", ParameterDirection.Input));

    await using var reader = await command.ExecuteReaderAsync(CommandBehavior.SequentialAccess, cancellationToken);
    var ordinals = GetOrdinals(reader);
    while (await reader.ReadAsync(cancellationToken))
    {
      var accountClass = ReadString(reader, ordinals, "ACCOUNT_CLASS");
      if (string.IsNullOrWhiteSpace(accountClass))
      {
        continue;
      }

      var currencyCode = ReadString(reader, ordinals, "CCY_CODE");
      var minimumOpeningBalance = ReadDecimal(reader, ordinals, "DFLT_MIN_OPEN_BAL");

      minimumBalanceByClass[accountClass] = (minimumOpeningBalance, string.IsNullOrWhiteSpace(currencyCode) ? "ETB" : currencyCode);
    }
  }

  private static Dictionary<string, int> GetOrdinals(DbDataReader reader)
  {
    var ordinals = new Dictionary<string, int>(StringComparer.OrdinalIgnoreCase);
    for (var index = 0; index < reader.FieldCount; index++)
    {
      ordinals[reader.GetName(index)] = index;
    }

    return ordinals;
  }

  private static string ReadString(DbDataReader reader, IReadOnlyDictionary<string, int> ordinals, params string[] columnNames)
  {
    foreach (var columnName in columnNames)
    {
      if (!ordinals.TryGetValue(columnName, out var ordinal) || reader.IsDBNull(ordinal))
      {
        continue;
      }

      return reader.GetValue(ordinal)?.ToString()?.Trim() ?? string.Empty;
    }

    return string.Empty;
  }

  private static decimal ReadDecimal(DbDataReader reader, IReadOnlyDictionary<string, int> ordinals, params string[] columnNames)
  {
    foreach (var columnName in columnNames)
    {
      if (!ordinals.TryGetValue(columnName, out var ordinal) || reader.IsDBNull(ordinal))
      {
        continue;
      }

      var rawValue = reader.GetValue(ordinal);
      if (rawValue is decimal decimalValue)
      {
        return decimalValue;
      }

      if (decimal.TryParse(rawValue?.ToString(), out var parsed))
      {
        return parsed;
      }
    }

    return 0m;
  }
}
