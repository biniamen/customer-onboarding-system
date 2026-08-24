namespace CustomerOnboarding.Backend.Options;

public class BsaOptions
{
  public string BaseUrl { get; set; } = string.Empty;
  public string ApiVersion { get; set; } = "2";
  public string InstitutionCode { get; set; } = string.Empty;
  public string Username { get; set; } = string.Empty;
  public string Password { get; set; } = string.Empty;
}
