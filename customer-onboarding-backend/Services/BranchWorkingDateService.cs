using System.Data;
using Oracle.ManagedDataAccess.Client;
using Oracle.ManagedDataAccess.Types;

namespace CustomerOnboarding.Backend.Services;

public class BranchWorkingDateService(IConfiguration configuration) : IBranchWorkingDateService
{
  private const string BranchTodaySql = """
    SELECT TODAY
    FROM FCUBS145.EVW_BRANCH_DATES
    WHERE TRIM(BRANCH_CODE) = :branchCode
    """;

  private readonly string _oracleConnectionString = configuration.GetConnectionString("OracleDb")
    ?? throw new InvalidOperationException("OracleDb connection string is not configured.");

  public async Task<string> GetBranchTodayAsync(string branchCode, CancellationToken cancellationToken = default)
  {
    if (string.IsNullOrWhiteSpace(branchCode))
    {
      return DateTime.Today.ToString("yyyy-MM-dd");
    }

    await using var connection = new OracleConnection(_oracleConnectionString);
    await using var command = new OracleCommand(BranchTodaySql, connection)
    {
      BindByName = true
    };
    command.Parameters.Add(new OracleParameter("branchCode", OracleDbType.Varchar2, branchCode.Trim(), ParameterDirection.Input));

    await connection.OpenAsync(cancellationToken);
    var result = await command.ExecuteScalarAsync(cancellationToken);

    var today = result switch
    {
      DateTime dateTime => dateTime,
      OracleDate oracleDate => oracleDate.Value,
      _ when DateTime.TryParse(result?.ToString(), out var parsed) => parsed,
      _ => DateTime.Today
    };

    return today.ToString("yyyy-MM-dd");
  }
}
