namespace CustomerOnboarding.Backend.Options;

public class PasswordManagementOptions
{
  public string DirectoryBaseUrl { get; set; } = string.Empty;
  public string DirectoryUsersPath { get; set; } = "/api/v1/User";
  public string DirectoryApiKeyHeader { get; set; } = "X-API-Key";
  public string DirectoryApiKey { get; set; } = string.Empty;
  public string SmsBaseUrl { get; set; } = "http://10.10.13.82:13131/cgi-bin/sendsms";
  public string SmsUsername { get; set; } = "playsms";
  public string SmsPassword { get; set; } = "playsms";
  public string SmsFrom { get; set; } = string.Empty;
  public int SmsPriority { get; set; } = 2;
  public bool SmsForceUnicodeMode { get; set; } = true;
  public bool SmsUseUcs2Hex { get; set; } = false;
  public string DefaultCountryCode { get; set; } = "+251";
}
