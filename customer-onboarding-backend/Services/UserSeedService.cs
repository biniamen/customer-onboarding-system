using CustomerOnboarding.Backend.Data;
using CustomerOnboarding.Backend.Models;
using CustomerOnboarding.Backend.Options;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;

namespace CustomerOnboarding.Backend.Services;

public class UserSeedService(
  AppDbContext dbContext,
  IPasswordHasher passwordHasher,
  IOptions<List<SeedUserOptions>> seedUsersOptions
) : IUserSeedService
{
  private readonly List<SeedUserOptions> _seedUsers = seedUsersOptions.Value;

  public async Task SeedAsync(CancellationToken cancellationToken = default)
  {
    foreach (var seedBranch in _seedUsers
      .Where(x => !string.IsNullOrWhiteSpace(x.BranchCode))
      .Select(x => new { BranchCode = x.BranchCode.Trim(), BranchName = (x.BranchName ?? string.Empty).Trim() })
      .Distinct())
    {
      var existingBranch = await dbContext.Branches.FirstOrDefaultAsync(x => x.BranchCode == seedBranch.BranchCode, cancellationToken);
      if (existingBranch is not null)
      {
        existingBranch.BranchName = string.IsNullOrWhiteSpace(seedBranch.BranchName) ? existingBranch.BranchName : seedBranch.BranchName;
        existingBranch.IsActive = true;
        continue;
      }

      dbContext.Branches.Add(new Branch
      {
        BranchCode = seedBranch.BranchCode,
        BranchName = string.IsNullOrWhiteSpace(seedBranch.BranchName) ? "Unknown Branch" : seedBranch.BranchName,
        IsActive = true
      });
    }

    foreach (var seedUser in _seedUsers)
    {
      var existingUser = await dbContext.Users.FirstOrDefaultAsync(x => x.Username == seedUser.Username, cancellationToken);
      if (existingUser is not null)
      {
        existingUser.FullName = seedUser.FullName;
        existingUser.PhoneNumber = seedUser.PhoneNumber;
        existingUser.BranchCode = seedUser.BranchCode;
        existingUser.BranchName = seedUser.BranchName;
        existingUser.Role = seedUser.Role;
        continue;
      }

      passwordHasher.CreateHash(seedUser.Password, out var hash, out var salt);
      dbContext.Users.Add(new AppUser
      {
        Username = seedUser.Username,
        FullName = seedUser.FullName,
        PhoneNumber = seedUser.PhoneNumber,
        BranchCode = seedUser.BranchCode,
        BranchName = seedUser.BranchName,
        Role = seedUser.Role,
        PasswordHash = hash,
        PasswordSalt = salt,
        MustChangePassword = seedUser.ForcePasswordChange,
        PasswordChangedAtUtc = seedUser.ForcePasswordChange ? null : DateTime.UtcNow,
        IsActive = true,
        CreatedAtUtc = DateTime.UtcNow
      });
    }

    await dbContext.SaveChangesAsync(cancellationToken);
  }
}
