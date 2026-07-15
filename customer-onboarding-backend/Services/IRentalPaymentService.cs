using CustomerOnboarding.Backend.Models;

namespace CustomerOnboarding.Backend.Services;

public interface IRentalPaymentService
{
  Task<RentalInquiryResult> InquireAsync(string billId, string balerId, CancellationToken cancellationToken = default);
  Task<RentalPaymentProcessingResult> ProcessPaymentAsync(RentalPaymentRequest record, string paymentMode, string? debitAccount, string makerBranchCode, decimal amount, string paidAt, string? tellerId, CancellationToken cancellationToken = default);
}

public record RentalInquiryResult(
  bool Success,
  string Message,
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
  DateTimeOffset? DueDate,
  string RawResponse
);

public record RentalPaymentProcessingResult(
  bool Success,
  string FinalStatus,
  string Message,
  string? CbsReference,
  string? ConfirmationCode,
  decimal PaidAmount,
  DateTimeOffset? PaidAtUtc,
  string RequestPayload,
  string ResponsePayload
);
