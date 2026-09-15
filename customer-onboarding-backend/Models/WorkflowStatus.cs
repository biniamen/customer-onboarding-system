namespace CustomerOnboarding.Backend.Models;

public static class WorkflowStatuses
{
  public const string Draft = "DRAFT";
  public const string PendingCheckerApproval = "PENDING_CHECKER_APPROVAL";
  public const string PendingKycAuthorization = "PENDING_KYC_AUTHORIZATION";
  public const string KycProcessing = "KYC_PROCESSING";
  public const string KycApproved = "KYC_APPROVED";
  public const string KycRejected = "KYC_REJECTED";
  public const string FulfillmentFailed = "FULFILLMENT_FAILED";
  public const string DuplicateCifBlocked = "DUPLICATE_CIF_BLOCKED";
  public const string Approved = "APPROVED";
  public const string Rejected = "REJECTED";
  public const string AccountCreated = "ACCOUNT_CREATED";
  public const string KycReviewed = "KYC_REVIEWED";
  public const string Failed = "FAILED";
}
