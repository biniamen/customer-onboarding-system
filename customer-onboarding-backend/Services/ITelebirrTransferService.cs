namespace CustomerOnboarding.Backend.Services;

public record TelebirrAccountValidationResult(
  bool Success,
  string Message,
  string AccountBranchCode,
  string AccountNumber,
  string CustomerNumber,
  string CustomerName,
  string AccountClass,
  string Currency,
  decimal AvailableBalance,
  string NoDebitStatus,
  string NoCreditStatus,
  string FrozenStatus,
  string ResponseStatus,
  string RawResponse
);

public record TelebirrAgentValidationResult(
  bool Success,
  string Message,
  string ShortCode,
  string OrganizationName,
  string ResultType,
  string ResultCode,
  string ResultDesc,
  string ConversationId,
  string RawResponse
);

public record TelebirrTransferProcessingResult(
  bool Success,
  string Message,
  string ServiceStatus,
  string? CbsReference,
  string? CbsMessageStatus,
  string? CbsResponseDesc,
  string? ReversalReference,
  string? ReversalStatus,
  string? ReversalResponseDesc,
  string? TransactionId,
  string? ConversationId,
  string? OriginatorConversationId,
  string? ResponseCode,
  string? ResponseDesc,
  string? ResultType,
  string? ResultCode,
  string? ResultDesc,
  string RequestPayload,
  string ResponsePayload
);

public interface ITelebirrTransferService
{
  decimal MinimumRemainingBalance { get; }
  string RequiredTransferCurrency { get; }

  Task<TelebirrAccountValidationResult> QueryCustomerAccountAsync(string branchCode, string accountNumber, CancellationToken cancellationToken = default);
  Task<TelebirrAgentValidationResult> QueryAgentAsync(string telebirrShortCode, CancellationToken cancellationToken = default);
  string? ValidateTransferRules(TelebirrAccountValidationResult accountResult, decimal amount);
  Task<TelebirrTransferProcessingResult> ProcessApprovedTransferAsync(string checkerBranchCode, string accountBranchCode, string checkerUserName, string checkerComment, int requestId, string accountNumber, string telebirrShortCode, decimal amount, string narration, CancellationToken cancellationToken = default);
}
