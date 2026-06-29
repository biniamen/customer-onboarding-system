using CustomerOnboarding.Backend.Dtos;

namespace CustomerOnboarding.Backend.Services;

public interface IFundingSourceLookupService
{
  Task<IReadOnlyList<EligibleFundingAccountDto>> GetEligibleAccountsAsync(string customerNumber, CancellationToken cancellationToken = default);
}
