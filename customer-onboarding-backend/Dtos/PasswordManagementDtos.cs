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

public record SendPasswordResetSmsRequest(
  string ExternalUserId,
  string Password
);

public record SendNewUserCredentialSmsRequest(
  string ExternalUserId,
  string Username,
  string Password
);

public record PasswordMessageDispatchResultDto(
  string TemplateType,
  string ExternalUserId,
  string FullEmployeeName,
  string PhoneNumber,
  string MessageBody,
  bool Sent,
  string ProviderMessage,
  string RawProviderResponse,
  DateTimeOffset SentAtUtc
);
