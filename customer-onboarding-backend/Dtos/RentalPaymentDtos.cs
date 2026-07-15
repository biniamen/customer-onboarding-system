namespace CustomerOnboarding.Backend.Dtos;

public record RentalPaymentInquiryRequest(
  string BillId,
  string BalerId
);

public record SubmitRentalPaymentRequest(
  string ManifestId,
  string BillId,
  decimal Amount,
  string PaymentMode,
  string? DebitAccount,
  string? PaidAt,
  string? TellerId
);

public record ApproveRentalPaymentRequest(string? CheckerComment);

public record RejectRentalPaymentRequest(string RejectionReason);

public record RentalPaymentInquiryDto(
  bool CanProceed,
  string Message,
  string? ManifestId,
  string BillId,
  string BalerId,
  string? CustomerId,
  string? CustomerName,
  string? TenantName,
  string? OwnerName,
  string? OwnerAccountNumber,
  string? PropertyName,
  string? BillDescription,
  string? Reason,
  decimal AmountDue,
  decimal BaseAmount,
  decimal PenaltyAmount,
  string? CurrentPeriod,
  string? PenaltyType,
  bool IsOverdue,
  string CashDebitGlAccount,
  string? DueDate,
  string RawResponse
);

public record RentalPaymentRecordDto(
  int Id,
  string ManifestId,
  string BillId,
  string BalerId,
  string? CustomerId,
  string? CustomerName,
  string? TenantName,
  string? OwnerName,
  string? OwnerAccountNumber,
  string? PropertyName,
  string? BillDescription,
  string? Reason,
  decimal AmountDue,
  decimal BaseAmount,
  decimal PenaltyAmount,
  decimal? PaidAmount,
  string Status,
  string? StatusMessage,
  string? DebitAccount,
  string? PaymentMode,
  string? MakerUserName,
  string? MakerBranchCode,
  string? CheckerUserName,
  string? CheckerBranchCode,
  string? CheckerComment,
  DateTimeOffset? ApprovedAt,
  DateTimeOffset? RejectedAt,
  string? RejectionReason,
  string? CbsReference,
  string? ConfirmationCode,
  string? PaidAtLocation,
  string? TellerId,
  DateTimeOffset? DueDate,
  DateTimeOffset? PaidAt,
  DateTimeOffset CreatedAt,
  DateTimeOffset UpdatedAt
);

public record RentalPaymentStatusDto(
  string ManifestId,
  string BillId,
  string Status,
  string? Message,
  string? CbsReference,
  string? ConfirmationCode,
  decimal AmountDue,
  decimal? PaidAmount,
  DateTimeOffset? PaidAt,
  DateTimeOffset UpdatedAt
);
