namespace CustomerOnboarding.Backend.Options;

public class JwtOptions
{
  public string Key { get; set; } = "CustomerOnboarding.SuperSecure.Jwt.Key.2026";
  public string Issuer { get; set; } = "CustomerOnboarding.Api";
  public string Audience { get; set; } = "CustomerOnboarding.App";
  public int ExpiryMinutes { get; set; } = 480;
}
