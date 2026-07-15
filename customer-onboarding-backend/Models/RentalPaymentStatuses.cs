namespace CustomerOnboarding.Backend.Models;

public static class RentalPaymentStatuses
{
  public const string Unpaid = "UNPAID";
  public const string PendingCheckerApproval = "PENDING_CHECKER_APPROVAL";
  public const string Processing = "PROCESSING";
  public const string CbsPostedCallbackPending = "CBS_POSTED_CALLBACK_PENDING";
  public const string CbsConfirmationRequired = "CBS_CONFIRMATION_REQUIRED";
  public const string Approved = "APPROVED";
  public const string Rejected = "REJECTED";
  public const string Paid = "PAID";
  public const string Failed = "FAILED";
}
