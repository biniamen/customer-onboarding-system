namespace CustomerOnboarding.Backend.Models;

public class AuditLog
{
  public long Id { get; set; }
  public Guid? UserId { get; set; }
  public AppUser? User { get; set; }
  public Guid? OnboardingRecordId { get; set; }
  public OnboardingRecord? OnboardingRecord { get; set; }
  public string Action { get; set; } = string.Empty;
  public string EntityName { get; set; } = string.Empty;
  public string EntityId { get; set; } = string.Empty;
  public string? DetailsJson { get; set; }
  public string? IpAddress { get; set; }
  public DateTime CreatedAtUtc { get; set; } = DateTime.UtcNow;
}
