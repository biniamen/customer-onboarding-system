using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using CustomerOnboarding.Backend.Models;
using CustomerOnboarding.Backend.Options;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;

namespace CustomerOnboarding.Backend.Services;

public class TokenService(IOptions<JwtOptions> jwtOptions) : ITokenService
{
  private readonly JwtOptions _jwtOptions = jwtOptions.Value;

  public string CreateToken(AppUser user, out DateTime expiresAtUtc)
  {
    expiresAtUtc = DateTime.UtcNow.AddMinutes(_jwtOptions.ExpiryMinutes);
    var claims = new List<Claim>
    {
      new(JwtRegisteredClaimNames.Sub, user.Id.ToString()),
      new(JwtRegisteredClaimNames.UniqueName, user.Username),
      new(ClaimTypes.NameIdentifier, user.Id.ToString()),
      new(ClaimTypes.Name, user.Username),
      new("full_name", user.FullName),
      new(ClaimTypes.Role, user.Role)
    };

    var credentials = new SigningCredentials(
      new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_jwtOptions.Key)),
      SecurityAlgorithms.HmacSha256
    );

    var token = new JwtSecurityToken(
      issuer: _jwtOptions.Issuer,
      audience: _jwtOptions.Audience,
      claims: claims,
      expires: expiresAtUtc,
      signingCredentials: credentials
    );

    return new JwtSecurityTokenHandler().WriteToken(token);
  }
}
