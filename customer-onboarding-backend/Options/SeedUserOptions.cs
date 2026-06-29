namespace CustomerOnboarding.Backend.Options;

public class SeedUserOptions
{
  public string Username { get; set; } = string.Empty;
  public string FullName { get; set; } = string.Empty;
  public string PhoneNumber { get; set; } = string.Empty;
  public string BranchCode { get; set; } = string.Empty;
  public string BranchName { get; set; } = string.Empty;
  public string Role { get; set; } = string.Empty;
  public string Password { get; set; } = string.Empty;
  public bool ForcePasswordChange { get; set; } = true;
}
