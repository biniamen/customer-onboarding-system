namespace CustomerOnboarding.Backend.Models;

public static class WorkflowStatuses
{
  public const string Draft = "DRAFT";
  public const string PendingCheckerApproval = "PENDING_CHECKER_APPROVAL";
  public const string Approved = "APPROVED";
  public const string Rejected = "REJECTED";
  public const string AccountCreated = "ACCOUNT_CREATED";
  public const string KycReviewed = "KYC_REVIEWED";
  public const string Failed = "FAILED";
}
