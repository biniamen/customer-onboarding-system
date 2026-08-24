namespace CustomerOnboarding.Backend.Dtos;

public record ResourceMobilizationEmployeeSearchResultDto(
  string Id,
  string EmployeeReference,
  string FullName,
  string? PhoneNumber,
  string? BranchCode,
  string? BranchName,
  string? DepartmentName,
  string? PositionName,
  string? Classification,
  bool IsActive,
  bool HasExistingRegistration,
  decimal? ExistingMonthlyTargetAmount,
  int? ExistingNewAccountCount
);

public record ResourceMobilizationTransactionLookupRequest(
  string? TransactionReferenceNo,
  string? AccountNumber,
  DateTimeOffset? FromDate,
  DateTimeOffset? ToDate,
  int Limit = 20
);

public record ResourceMobilizationTransactionDto(
  string TransactionReferenceNo,
  string DepositBranchCode,
  string DepositBranchName,
  string AccountNumber,
  string Currency,
  decimal Amount,
  DateTimeOffset ValueDate,
  string? CustomerNumber,
  string CustomerName,
  string? AccountClass,
  string SuggestedProductType,
  string RawPayload,
  bool AlreadyRegistered,
  int? ExistingRecordId,
  string? ExistingRegistrationReference,
  string? ExistingStatus,
  string? ExistingEmployeeReference,
  string? ExistingEmployeeFullName
);

public record ResourceMobilizationRegistrationStatusDto(
  bool IsRegistered,
  int? ExistingRecordId,
  string? ExistingRegistrationReference,
  string? ExistingStatus,
  string? ExistingEmployeeReference,
  string? ExistingEmployeeFullName,
  DateTimeOffset? CreatedAt
);

public record SubmitResourceMobilizationRequest(
  string? EmployeeDirectoryEntryId,
  IReadOnlyList<string>? EmployeeDirectoryEntryIds,
  bool IsJointRegistration,
  decimal MonthlyTargetAmount,
  string DepositProductType,
  int NewAccountCount,
  string TransactionReferenceNo,
  string AccountNumber,
  string? DepositorCustomerName
);

public record ApproveResourceMobilizationRequest(string? CheckerComment);

public record RejectResourceMobilizationRequest(string RejectionReason);

public record ResourceMobilizationRecordDto(
  int Id,
  string RegistrationReference,
  string RegistrationBatchReference,
  bool IsJointRegistration,
  int JointParticipantCount,
  int JointSequenceNumber,
  string EmployeeReference,
  string EmployeeFullName,
  string? EmployeePhoneNumber,
  string? EmployeeBranchCode,
  string? EmployeeBranchName,
  string? EmployeeDepartmentName,
  string? EmployeePositionName,
  string? EmployeeClassification,
  decimal MonthlyTargetAmount,
  string DepositProductType,
  decimal SourceTransactionAmount,
  decimal TotalDepositMobilized,
  int NewAccountCount,
  string DepositorCustomerName,
  string? DepositorCustomerNumber,
  string DepositorAccountNumber,
  string? DepositorAccountClass,
  string TransactionReferenceNo,
  string DepositBranchCode,
  string? DepositBranchName,
  string TransactionCurrency,
  DateTimeOffset TransactionValueDate,
  string Status,
  string? MakerUserName,
  string? MakerBranchCode,
  string? MakerBranchName,
  string? CheckerUserName,
  string? CheckerBranchCode,
  string? CheckerBranchName,
  string? CheckerComment,
  string? RejectionReason,
  DateTimeOffset CreatedAt,
  DateTimeOffset UpdatedAt,
  DateTimeOffset? ApprovedAt,
  DateTimeOffset? RejectedAt
);

public class ResourceMobilizationReportQueryDto
{
  public string? Search { get; set; }
  public string? Status { get; set; }
  public string? DepositProductType { get; set; }
  public DateTimeOffset? FromDate { get; set; }
  public DateTimeOffset? ToDate { get; set; }
  public int Page { get; set; } = 1;
  public int PageSize { get; set; } = 20;
  public string? SortBy { get; set; } = "transactionValueDate";
  public string? SortDirection { get; set; } = "desc";
}

public record ResourceMobilizationReportResponseDto(
  int Page,
  int PageSize,
  int TotalRecords,
  int TotalPages,
  IReadOnlyList<ResourceMobilizationRecordDto> Items
);

public record ResourceMobilizationStatusBreakdownDto(
  int Total,
  int Pending,
  int Approved,
  int Rejected,
  decimal ApprovedAmount,
  int DistinctEmployees
);

public record ResourceMobilizationLeaderboardItemDto(
  string EmployeeReference,
  string EmployeeFullName,
  string? EmployeeDepartmentName,
  string? EmployeeBranchCode,
  string? EmployeeBranchName,
  decimal TotalAmount,
  int TransactionCount,
  int TotalNewAccounts
);

public record ResourceMobilizationDashboardPeriodDto(
  DateTimeOffset RangeStartUtc,
  DateTimeOffset RangeEndUtc,
  ResourceMobilizationStatusBreakdownDto Totals,
  IReadOnlyList<ResourceMobilizationLeaderboardItemDto> TopMobilizers
);

public record ResourceMobilizationDashboardStatsDto(
  string Scope,
  string? BranchCode,
  ResourceMobilizationDashboardPeriodDto Today,
  ResourceMobilizationDashboardPeriodDto ThisWeek,
  ResourceMobilizationDashboardPeriodDto ThisMonth
);
