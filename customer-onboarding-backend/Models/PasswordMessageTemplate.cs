namespace CustomerOnboarding.Backend.Models;

public class PasswordMessageTemplate
{
  public int Id { get; set; }
  public string TemplateType { get; set; } = string.Empty;
  public string Title { get; set; } = string.Empty;
  public string Body { get; set; } = string.Empty;
  public bool IsActive { get; set; } = true;
  public DateTimeOffset UpdatedAtUtc { get; set; } = DateTimeOffset.UtcNow;
  public string UpdatedByUserName { get; set; } = string.Empty;
}

public static class PasswordMessageTemplateTypes
{
  public const string PasswordReset = "PASSWORD_RESET";
  public const string NewUserCreation = "NEW_USER_CREATION";

  public static readonly string[] All =
  [
    PasswordReset,
    NewUserCreation
  ];
}

public static class PasswordMessageSystems
{
  public const string FlexcubeCoreBanking = "Flexcube Core banking";
  public const string CheckPointSystem = "Check Point System";
  public const string Webmail = "Webmail";
  public const string BiReport = "BI Report";

  public static readonly string[] All =
  [
    FlexcubeCoreBanking,
    CheckPointSystem,
    Webmail,
    BiReport
  ];

  public static bool TryNormalize(string? value, out string normalized)
  {
    var candidate = (value ?? string.Empty).Trim();
    normalized = All.FirstOrDefault(item => string.Equals(item, candidate, StringComparison.OrdinalIgnoreCase)) ?? string.Empty;
    return !string.IsNullOrWhiteSpace(normalized);
  }
}
