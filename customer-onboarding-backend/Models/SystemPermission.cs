namespace CustomerOnboarding.Backend.Models;

public class SystemPermission
{
  public int Id { get; set; }
  public string Code { get; set; } = string.Empty;
  public string Name { get; set; } = string.Empty;
  public string? Description { get; set; }
  public bool IsActive { get; set; } = true;
  public DateTimeOffset CreatedAtUtc { get; set; } = DateTimeOffset.UtcNow;
  public DateTimeOffset UpdatedAtUtc { get; set; } = DateTimeOffset.UtcNow;
  public ICollection<RolePermission> RoleAssignments { get; set; } = new List<RolePermission>();
}
