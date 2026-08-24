namespace CustomerOnboarding.Backend.Models;

public class BsaSubmissionRecord
{
  public int Id { get; set; }
  public string SubmissionReference { get; set; } = string.Empty;
  public string ReturnKey { get; set; } = string.Empty;
  public string InstitutionCode { get; set; } = string.Empty;
  public int FinancialYear { get; set; }
  public DateTimeOffset PeriodStart { get; set; }
  public DateTimeOffset PeriodEnd { get; set; }
  public string? BsaFileName { get; set; }
  public string SubmissionStatus { get; set; } = BsaSubmissionStatuses.Created;
  public string? Notification { get; set; }
  public string? LastProcessingStatus { get; set; }
  public string? CreatedByUserName { get; set; }
  public string? CreatedByBranchCode { get; set; }
  public DateTimeOffset CreatedAt { get; set; } = DateTimeOffset.UtcNow;
  public DateTimeOffset UpdatedAt { get; set; } = DateTimeOffset.UtcNow;
  public DateTimeOffset? SubmittedAt { get; set; }
  public DateTimeOffset? LastStatusCheckedAt { get; set; }
  public DateTimeOffset? CompletedAt { get; set; }
  public string? RequestPayload { get; set; }
  public string? SubmissionResponsePayload { get; set; }
  public string? StatusResponsePayload { get; set; }
  public string? DiscardRequestPayload { get; set; }
  public string? DiscardResponsePayload { get; set; }
  public string? ErrorMessage { get; set; }
}
