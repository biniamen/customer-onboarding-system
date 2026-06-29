using System.Data;
using System.Data.Common;
using CustomerOnboarding.Backend.Dtos;
using Oracle.ManagedDataAccess.Client;

namespace CustomerOnboarding.Backend.Services;

public class FundingSourceLookupService(IConfiguration configuration) : IFundingSourceLookupService
{
  private const string AccountLookupSql = """
    SELECT *
    FROM FCUBS145.STTM_CUST_ACCOUNT
    WHERE CUST_NO = :customerNo
    ORDER BY CUST_AC_NO
    """;

  private readonly string _oracleConnectionString = configuration.GetConnectionString("OracleDb")
    ?? throw new InvalidOperationException("OracleDb connection string is not configured.");

  public async Task<IReadOnlyList<EligibleFundingAccountDto>> GetEligibleAccountsAsync(string customerNumber, CancellationToken cancellationToken = default)
  {
    if (string.IsNullOrWhiteSpace(customerNumber))
    {
      return [];
    }

    var accounts = new List<EligibleFundingAccountDto>();

    await using var connection = new OracleConnection(_oracleConnectionString);
    await using var command = new OracleCommand(AccountLookupSql, connection)
    {
      BindByName = true
    };
    command.Parameters.Add(new OracleParameter("customerNo", OracleDbType.Varchar2, customerNumber.Trim(), ParameterDirection.Input));

    await connection.OpenAsync(cancellationToken);
    await using var reader = await command.ExecuteReaderAsync(CommandBehavior.SequentialAccess, cancellationToken);

    var ordinals = GetOrdinals(reader);
    while (await reader.ReadAsync(cancellationToken))
    {
      var accountNumber = ReadString(reader, ordinals, "CUST_AC_NO");
      var description = ReadString(reader, ordinals, "AC_DESC");
      var currency = ReadString(reader, ordinals, "CCY");
      var accountClass = ReadString(reader, ordinals, "ACCOUNT_CLASS");
      var noDebitStatus = ReadString(reader, ordinals, "AC_STAT_NO_DR", "NO_DR");
      var dormantStatus = ReadString(reader, ordinals, "AC_STAT_DORMANT");
      var joinIndicator = ReadString(reader, ordinals, "JOIN_AC_INICATOR");

      if (string.IsNullOrWhiteSpace(accountNumber))
      {
        continue;
      }

      if (!string.Equals(noDebitStatus, "N", StringComparison.OrdinalIgnoreCase) ||
          !string.Equals(dormantStatus, "N", StringComparison.OrdinalIgnoreCase) ||
          !string.Equals(joinIndicator, "S", StringComparison.OrdinalIgnoreCase))
      {
        continue;
      }

      accounts.Add(new EligibleFundingAccountDto(
        accountNumber,
        description,
        currency,
        accountClass,
        noDebitStatus,
        dormantStatus,
        joinIndicator
      ));
    }

    return accounts;
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
}
