namespace CustomerOnboarding.Backend.Models;

public static class BsaSubmissionStatuses
{
  public const string Created = "CREATED";
  public const string Submitted = "SUBMITTED";
  public const string Processing = "PROCESSING";
  public const string ProcessedSuccessfully = "PROCESSED_SUCCESSFULLY";
  public const string ProcessingFailed = "PROCESSING_FAILED";
  public const string ValidationFailed = "VALIDATION_FAILED";
  public const string AuthenticationFailed = "AUTHENTICATION_FAILED";
  public const string Discarded = "DISCARDED";
}
