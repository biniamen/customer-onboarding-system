using CustomerOnboarding.Backend.Dtos;

namespace CustomerOnboarding.Backend.Services;

public interface IAccountClassLookupService
{
  Task<IReadOnlyList<AccountClassOptionDto>> GetAccountClassesAsync(CancellationToken cancellationToken = default);
}
