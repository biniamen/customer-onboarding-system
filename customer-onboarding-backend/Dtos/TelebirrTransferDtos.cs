namespace CustomerOnboarding.Backend.Dtos;

public record TelebirrAccountLookupRequest(string AccountNumber);

public record TelebirrAgentLookupRequest(string TelebirrShortCode);

public record SubmitTelebirrTransferRequest(
  string AccountNumber,
  string TelebirrShortCode,
  decimal Amount,
  string? Narration
);

public record ApproveTelebirrTransferRequest(string? CheckerComment);

public record RejectTelebirrTransferRequest(string RejectionReason);

public record TelebirrAccountLookupDto(
  string AccountNumber,
  string AccountBranchCode,
  string CustomerNumber,
  string CustomerName,
  string AccountClass,
  string Currency,
  decimal AvailableBalance,
  string NoDebitStatus,
  string NoCreditStatus,
  string FrozenStatus,
  string ResponseStatus,
  bool CanProceed,
  decimal MinimumRemainingBalance,
  string Message,
  string RawResponse
);

public record TelebirrAgentLookupDto(
  string TelebirrShortCode,
  string TelebirrOrganizationName,
  string ResultType,
  string ResultCode,
  string ResultDesc,
  string ConversationId,
  bool IsValid,
  string Message,
  string RawResponse
);

public record TelebirrTransferRecordDto(
  int Id,
  string AccountNumber,
  string? AccountBranchCode,
  string? CustomerName,
  string TelebirrShortCode,
  string? TelebirrOrganizationName,
  decimal Amount,
  string Currency,
  string Narration,
  string Status,
  int? MakerBranchId,
  string? MakerUserName,
  string? CheckerUserName,
  DateTimeOffset CreatedAt,
  DateTimeOffset? ApprovedAt,
  DateTimeOffset? RejectedAt,
  string? RejectionReason,
  string? TransactionId,
  string? ConversationId,
  string? OriginatorConversationId,
  string? CbsReference,
  string? CbsMessageStatus,
  string? CbsResponseDesc,
  string? ReversalReference,
  string? ReversalStatus,
  string? ReversalResponseDesc,
  string? ResponseCode,
  string? ResponseDesc,
  string? ServiceStatus,
  string? ResultType,
  string? ResultCode,
  string? ResultDesc
);

public class TelebirrTransferReportQueryDto
{
  public string? Search { get; set; }
  public string? Status { get; set; }
  public DateTimeOffset? FromDate { get; set; }
  public DateTimeOffset? ToDate { get; set; }
  public int Page { get; set; } = 1;
  public int PageSize { get; set; } = 20;
  public string? SortBy { get; set; } = "createdAt";
  public string? SortDirection { get; set; } = "desc";
}

public record TelebirrTransferReportResponseDto(
  int Page,
  int PageSize,
  int TotalRecords,
  int TotalPages,
  IReadOnlyList<TelebirrTransferRecordDto> Items
);

public record TelebirrStatusBreakdownDto(
  int Total,
  int Approved,
  int Failed,
  int Rejected,
  int Pending,
  int DistinctAgents,
  decimal TotalTransferredAmount
);

public record TelebirrBranchStatsDto(
  string BranchCode,
  string BranchName,
  TelebirrStatusBreakdownDto Today,
  TelebirrStatusBreakdownDto GrandTotal
);

public record TelebirrDashboardUserStatsDto(
  int TotalUsers,
  int ActiveUsers,
  int InactiveUsers
);

public record TelebirrDashboardStatsDto(
  string Scope,
  string? BranchCode,
  DateTimeOffset RangeStartUtc,
  DateTimeOffset RangeEndUtc,
  TelebirrStatusBreakdownDto Today,
  TelebirrStatusBreakdownDto GrandTotal,
  IReadOnlyList<TelebirrBranchStatsDto> Branches,
  TelebirrDashboardUserStatsDto? UserStats
);
