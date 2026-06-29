using CustomerOnboarding.Backend.Models;

namespace CustomerOnboarding.Backend.Services;

public interface ITokenService
{
  string CreateToken(AppUser user, out DateTime expiresAtUtc);
}
