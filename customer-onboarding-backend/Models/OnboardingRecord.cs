namespace CustomerOnboarding.Backend.Models;

public class OnboardingRecord
{
  public Guid Id { get; set; } = Guid.NewGuid();
  public string CaseReference { get; set; } = string.Empty;
  public string Status { get; set; } = WorkflowStatuses.PendingCheckerApproval;
  public Guid MakerUserId { get; set; }
  public AppUser? MakerUser { get; set; }
  public Guid? CheckerUserId { get; set; }
  public AppUser? CheckerUser { get; set; }
  public Guid? KycReviewerUserId { get; set; }
  public AppUser? KycReviewerUser { get; set; }
  public string Fan { get; set; } = string.Empty;
  public string Psut { get; set; } = string.Empty;
  public string CustomerNumber { get; set; } = string.Empty;
  public string CustomerName { get; set; } = string.Empty;
  public string BranchCode { get; set; } = string.Empty;
  public string AccountClass { get; set; } = string.Empty;
  public string AccountClassName { get; set; } = string.Empty;
  public decimal OpeningAmount { get; set; }
  public string FundingSourceType { get; set; } = string.Empty;
  public string FundingSourceValue { get; set; } = string.Empty;
  public string AccountReference { get; set; } = string.Empty;
  public bool AssetsReady { get; set; } = true;
  public string Email { get; set; } = string.Empty;
  public string MobileNumber { get; set; } = string.Empty;
  public string PlaceOfBirth { get; set; } = string.Empty;
  public string IdType { get; set; } = string.Empty;
  public string? ResidentIdNumber { get; set; }
  public string? TinNumber { get; set; }
  public bool HasCustomerPhoto { get; set; }
  public bool HasSignature { get; set; }
  public bool HasRequiredDocuments { get; set; }
  public string SnapshotJson { get; set; } = "{}";
  public string AdditionalDetailsJson { get; set; } = "{}";
  public string CifResponseJson { get; set; } = "{}";
  public string AccountDetailsJson { get; set; } = "{}";
  public string UploadResponseJson { get; set; } = "{}";
  public string DocumentsJson { get; set; } = "[]";
  public string? CheckerComment { get; set; }
  public string? AccountNumber { get; set; }
  public string? AccountServiceResponseXml { get; set; }
  public string? LastError { get; set; }
  public DateTime CreatedAtUtc { get; set; } = DateTime.UtcNow;
  public DateTime UpdatedAtUtc { get; set; } = DateTime.UtcNow;
  public DateTime SubmittedAtUtc { get; set; } = DateTime.UtcNow;
  public DateTime? ReviewedAtUtc { get; set; }
  public DateTime? KycReviewedAtUtc { get; set; }
}
