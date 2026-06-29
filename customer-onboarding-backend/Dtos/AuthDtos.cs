namespace CustomerOnboarding.Backend.Dtos;

public record LoginRequest(string Username, string Password);

public record LoginResponse(
  string Token,
  DateTime ExpiresAtUtc,
  UserProfileDto User
);

public record UserProfileDto(
  Guid Id,
  string Username,
  string FullName,
  string PhoneNumber,
  string BranchCode,
  string BranchName,
  string Role,
  bool MustChangePassword
);

public record ChangePasswordRequest(
  string CurrentPassword,
  string NewPassword
);
