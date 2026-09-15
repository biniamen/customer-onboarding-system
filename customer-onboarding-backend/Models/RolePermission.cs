namespace CustomerOnboarding.Backend.Models;

public class RolePermission
{
  public int Id { get; set; }
  public string Role { get; set; } = string.Empty;
  public int PermissionId { get; set; }
  public SystemPermission Permission { get; set; } = null!;
  public DateTimeOffset AssignedAtUtc { get; set; } = DateTimeOffset.UtcNow;
  public string AssignedByUserName { get; set; } = string.Empty;
}
