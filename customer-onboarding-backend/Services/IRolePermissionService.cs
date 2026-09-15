namespace CustomerOnboarding.Backend.Services;

public interface IRolePermissionService
{
  Task<bool> HasPermissionAsync(string? role, string permissionCode, CancellationToken cancellationToken = default);
}
