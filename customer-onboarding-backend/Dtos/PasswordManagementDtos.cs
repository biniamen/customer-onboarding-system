namespace CustomerOnboarding.Backend.Dtos;


public record ExternalDirectoryUserDto(
  string Id,
  string EmployeeId,
  string FirstName,
  string MiddleName,
  string LastName,
  string FullEmployeeName,
  string Gender,
  string Email,
  string PhoneNumber,
  bool IsActive,
  string? BranchId,
  string? BranchName,
  string? BranchCode,
  string? DepartmentId,
  string? DepartmentName,
  string? RoleId,
  string? RoleName,
  string? PositionId,
  string? PositionName,
  bool MustChangePassword,
  DateTimeOffset? LastPasswordResetAt,
  string? LastPasswordResetByUserId,
  DateTimeOffset? CreatedAt,
  DateTimeOffset? UpdatedAt
);

public record PasswordMessageTemplateDto(
  string TemplateType,
  string Title,
  string Body,
  bool IsActive,
  DateTimeOffset UpdatedAtUtc,
  string UpdatedByUserName
);

public record UpdatePasswordMessageTemplateRequest(
  string Title,
  string Body,
  bool IsActive = true
);

public record PasswordManagedSystemDto(
  int Id,
  string Name,
  bool IsActive,
  DateTimeOffset UpdatedAtUtc,
  string UpdatedByUserName
);

public record CreatePasswordManagedSystemRequest(string Name);

public record UpdatePasswordManagedSystemRequest(string Name, bool IsActive);

public record SendPasswordResetSmsRequest(
  string ExternalUserId,
  string SystemName,
  string Password
);

public record SendNewUserCredentialSmsRequest(
  string ExternalUserId,
  string SystemName,
  string Username,
  string Password
);

public record PasswordMessageDispatchResultDto(
  string TemplateType,
  string ExternalUserId,
  string FullEmployeeName,
  string PhoneNumber,
  string SystemName,
  string MessageBody,
  bool Sent,
  string ProviderMessage,
  string RawProviderResponse,
  DateTimeOffset SentAtUtc
);

public record EmployeeDirectoryStatsDto(
  int TotalEmployees,
  int ActiveEmployees,
  DateTimeOffset? LastImportedAtUtc,
  string? LastSourceFileName
);

public record EmployeeDirectoryImportResultDto(
  string SourceFileName,
  string SourceSheetName,
  int ProcessedRows,
  int InsertedRows,
  int UpdatedRows,
  int DeactivatedRows,
  int TotalActiveEmployees,
  DateTimeOffset ImportedAtUtc
);

public class EmployeeDirectoryQueryDto
{
  public string? Search { get; set; }
  public string? BranchCode { get; set; }
  public bool? IsActive { get; set; }
  public int Page { get; set; } = 1;
  public int PageSize { get; set; } = 20;
}

public record EmployeeDirectoryListItemDto(
  string Id,
  int? SequenceNumber,
  string EmployeeReference,
  string EmployeeCode,
  string InternalNumber,
  string InternalNumberExtension,
  string FirstName,
  string MiddleName,
  string LastName,
  string FullEmployeeName,
  string Gender,
  string ContactAddress,
  string PhoneNumber,
  string CurrentPosition,
  string Classification,
  string AssignedUnitName,
  string BranchGrade,
  string BranchCode,
  string District,
  DateOnly? EmploymentDate,
  bool IsActive,
  string SourceFileName,
  string SourceSheetName,
  DateTimeOffset ImportedAtUtc,
  DateTimeOffset UpdatedAtUtc
);

public record EmployeeDirectoryPagedResponseDto(
  int Page,
  int PageSize,
  int TotalRecords,
  int TotalPages,
  IReadOnlyList<EmployeeDirectoryListItemDto> Items
);

public record UpdateEmployeeDirectoryEntryRequest(
  int? SequenceNumber,
  string EmployeeReference,
  string EmployeeCode,
  string InternalNumber,
  string InternalNumberExtension,
  string FirstName,
  string MiddleName,
  string LastName,
  string FullEmployeeName,
  string Gender,
  string ContactAddress,
  string PhoneNumber,
  string CurrentPosition,
  string Classification,
  string AssignedUnitName,
  string BranchGrade,
  string BranchCode,
  string District,
  DateOnly? EmploymentDate,
  bool IsActive
);

public class PasswordMessageAuditLogQueryDto
{
  public string? Search { get; set; }
  public DateTimeOffset? FromDate { get; set; }
  public DateTimeOffset? ToDate { get; set; }
  public int Page { get; set; } = 1;
  public int PageSize { get; set; } = 20;
}

public record PasswordMessageAuditLogDto(
  long Id,
  string Action,
  string? OperatorUsername,
  string? OperatorFullName,
  string? RecipientFullEmployeeName,
  string? RecipientPhoneNumber,
  string? SystemName,
  string? ProvisionedUsername,
  bool? Sent,
  string? IpAddress,
  DateTime CreatedAtUtc
);

public record PasswordMessageAuditLogResponseDto(
  int Page,
  int PageSize,
  int TotalRecords,
  int TotalPages,
  IReadOnlyList<PasswordMessageAuditLogDto> Items
);
