using CustomerOnboarding.Backend.Models;

namespace CustomerOnboarding.Backend.Services;

public interface IAccountApprovalService
{
  Task<(bool Success, bool StatusChangeSuccess, string Message, string AccountNumber, string RawResponse)> CreateAccountAsync(OnboardingRecord record, CancellationToken cancellationToken = default);
}
