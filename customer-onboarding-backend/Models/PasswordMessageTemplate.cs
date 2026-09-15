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

public class PasswordManagedSystem
{
  public int Id { get; set; }
  public string Name { get; set; } = string.Empty;
  public string NormalizedName { get; set; } = string.Empty;
  public bool IsActive { get; set; } = true;
  public DateTimeOffset CreatedAtUtc { get; set; } = DateTimeOffset.UtcNow;
  public string CreatedByUserName { get; set; } = string.Empty;
  public DateTimeOffset UpdatedAtUtc { get; set; } = DateTimeOffset.UtcNow;
  public string UpdatedByUserName { get; set; } = string.Empty;
}
