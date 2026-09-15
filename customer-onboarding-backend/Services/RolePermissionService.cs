using CustomerOnboarding.Backend.Data;
using Microsoft.EntityFrameworkCore;

namespace CustomerOnboarding.Backend.Services;

public class RolePermissionService(AppDbContext dbContext) : IRolePermissionService
{
  public Task<bool> HasPermissionAsync(string? role, string permissionCode, CancellationToken cancellationToken = default)
  {
    var normalizedRole = (role ?? string.Empty).Trim().ToUpperInvariant();
    var normalizedCode = (permissionCode ?? string.Empty).Trim().ToUpperInvariant();

    if (string.IsNullOrWhiteSpace(normalizedRole) || string.IsNullOrWhiteSpace(normalizedCode))
    {
      return Task.FromResult(false);
    }

    return dbContext.RolePermissions
      .AsNoTracking()
      .AnyAsync(
        assignment => assignment.Role == normalizedRole &&
          assignment.Permission.Code == normalizedCode &&
          assignment.Permission.IsActive,
        cancellationToken
      );
  }
}
