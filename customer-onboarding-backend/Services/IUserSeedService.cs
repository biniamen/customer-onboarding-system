namespace CustomerOnboarding.Backend.Services;

public interface IUserSeedService
{
  Task SeedAsync(CancellationToken cancellationToken = default);
}
