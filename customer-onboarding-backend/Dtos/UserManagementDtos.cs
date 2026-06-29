namespace CustomerOnboarding.Backend.Dtos;

public record BranchDto(
  string BranchCode,
  string BranchName
);

public record AdminUserListItemDto(
  Guid Id,
  string Username,
  string FullName,
  string PhoneNumber,
  string BranchCode,
  string BranchName,
  string Role,
  bool IsActive,
  bool MustChangePassword,
  DateTime CreatedAtUtc,
  DateTime? LastLoginAtUtc,
  DateTime? PasswordChangedAtUtc
);

public record CreateUserRequest(
  string Username,
  string FullName,
  string PhoneNumber,
  string BranchCode,
  string Role,
  string Password,
  bool IsActive = true
);

public record UpdateUserRequest(
  string FullName,
  string PhoneNumber,
  string BranchCode,
  string Role,
  bool IsActive
);

public record ResetUserPasswordRequest(
  string NewPassword,
  bool ForcePasswordChange = true
);
