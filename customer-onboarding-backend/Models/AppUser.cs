namespace CustomerOnboarding.Backend.Models;

public class AppUser
{
  public Guid Id { get; set; } = Guid.NewGuid();
  public string Username { get; set; } = string.Empty;
  public string FullName { get; set; } = string.Empty;
  public string PhoneNumber { get; set; } = string.Empty;
  public string BranchCode { get; set; } = string.Empty;
  public string BranchName { get; set; } = string.Empty;
  public string Role { get; set; } = UserRoles.Maker;
  public byte[] PasswordHash { get; set; } = Array.Empty<byte>();
  public byte[] PasswordSalt { get; set; } = Array.Empty<byte>();
  public bool MustChangePassword { get; set; } = true;
  public DateTime? PasswordChangedAtUtc { get; set; }
  public bool IsActive { get; set; } = true;
  public DateTime CreatedAtUtc { get; set; } = DateTime.UtcNow;
  public DateTime? LastLoginAtUtc { get; set; }
}
