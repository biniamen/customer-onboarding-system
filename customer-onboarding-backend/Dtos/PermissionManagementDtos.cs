namespace CustomerOnboarding.Backend.Dtos;

public record SystemPermissionDto(
  int Id,
  string Code,
  string Name,
  string? Description,
  bool IsActive,
  DateTimeOffset CreatedAtUtc,
  DateTimeOffset UpdatedAtUtc,
  IReadOnlyList<string> AssignedRoles
);

public record RolePermissionAssignmentDto(
  string Role,
  IReadOnlyList<string> PermissionCodes
);

public record PermissionManagementSnapshotDto(
  IReadOnlyList<SystemPermissionDto> Permissions,
  IReadOnlyList<RolePermissionAssignmentDto> RoleAssignments
);

public record CreateSystemPermissionRequest(
  string Code,
  string Name,
  string? Description,
  bool IsActive = true
);

public record UpdateSystemPermissionRequest(
  string Name,
  string? Description,
  bool IsActive
);

public record UpdateRolePermissionsRequest(
  IReadOnlyList<string>? PermissionCodes
);
