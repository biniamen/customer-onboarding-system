namespace CustomerOnboarding.Backend.Services;

public interface IBranchWorkingDateService
{
  Task<string> GetBranchTodayAsync(string branchCode, CancellationToken cancellationToken = default);
}
