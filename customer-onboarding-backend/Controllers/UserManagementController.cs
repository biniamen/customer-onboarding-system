using System.Security.Claims;
using CustomerOnboarding.Backend.Data;
using CustomerOnboarding.Backend.Dtos;
using CustomerOnboarding.Backend.Models;
using CustomerOnboarding.Backend.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace CustomerOnboarding.Backend.Controllers;

[ApiController]
[Route("api/core/admin")]
[Authorize(Roles = UserRoles.Admin)]
public class UserManagementController(
  AppDbContext dbContext,
  IPasswordHasher passwordHasher,
  IAuditService auditService
) : ControllerBase
{
  private static readonly string[] AllowedRoles =
  [
    UserRoles.Admin,
    UserRoles.Maker,
    UserRoles.Checker,
    UserRoles.RentalMaker,
    UserRoles.RentalChecker,
    UserRoles.ReportViewer,
    UserRoles.KycUnit
  ];

  [HttpGet("branches")]
  public async Task<ActionResult<IReadOnlyList<BranchDto>>> GetBranches(CancellationToken cancellationToken)
  {
    var branches = await dbContext.Branches
      .AsNoTracking()
      .Where(x => x.IsActive)
      .OrderBy(x => x.BranchCode)
      .Select(x => new BranchDto(x.BranchCode, x.BranchName))
      .ToListAsync(cancellationToken);

    return Ok(branches);
  }

  [HttpGet("users")]
  public async Task<ActionResult<IReadOnlyList<AdminUserListItemDto>>> GetUsers(CancellationToken cancellationToken)
  {
    var users = await dbContext.Users
      .AsNoTracking()
      .OrderBy(x => x.Username)
      .Select(x => MapUser(x))
      .ToListAsync(cancellationToken);

    return Ok(users);
  }

  [HttpPost("users")]
  public async Task<ActionResult<AdminUserListItemDto>> CreateUser([FromBody] CreateUserRequest request, CancellationToken cancellationToken)
  {
    var username = (request.Username ?? string.Empty).Trim();
    if (string.IsNullOrWhiteSpace(username) || username.Length < 3)
    {
      return BadRequest(new { message = "Username must be at least 3 characters." });
    }

    if (string.IsNullOrWhiteSpace(request.Password) || request.Password.Trim().Length < 8)
    {
      return BadRequest(new { message = "Password must be at least 8 characters." });
    }

    if (!IsValidRole(request.Role))
    {
      return BadRequest(new { message = "Invalid role selected." });
    }

    var branch = await dbContext.Branches
      .FirstOrDefaultAsync(x => x.BranchCode == (request.BranchCode ?? string.Empty).Trim() && x.IsActive, cancellationToken);
    if (branch is null)
    {
      return BadRequest(new { message = "Please select a valid branch." });
    }

    var exists = await dbContext.Users.AnyAsync(x => x.Username == username, cancellationToken);
    if (exists)
    {
      return Conflict(new { message = "Username already exists." });
    }

    passwordHasher.CreateHash(request.Password.Trim(), out var hash, out var salt);
    var user = new AppUser
    {
      Username = username,
      FullName = (request.FullName ?? string.Empty).Trim(),
      PhoneNumber = (request.PhoneNumber ?? string.Empty).Trim(),
      BranchCode = branch.BranchCode,
      BranchName = branch.BranchName,
      Role = request.Role.Trim().ToUpperInvariant(),
      PasswordHash = hash,
      PasswordSalt = salt,
      IsActive = request.IsActive,
      MustChangePassword = true,
      PasswordChangedAtUtc = null,
      CreatedAtUtc = DateTime.UtcNow
    };

    dbContext.Users.Add(user);
    await dbContext.SaveChangesAsync(cancellationToken);

    await auditService.LogAsync(
      GetCurrentUserId(),
      null,
      "CREATE_USER",
      "AppUser",
      user.Id.ToString(),
      new { user.Username, user.Role, user.BranchCode },
      HttpContext.Connection.RemoteIpAddress?.ToString(),
      cancellationToken
    );

    return CreatedAtAction(nameof(GetUsers), new { id = user.Id }, MapUser(user));
  }

  [HttpPut("users/{id:guid}")]
  public async Task<ActionResult<AdminUserListItemDto>> UpdateUser(Guid id, [FromBody] UpdateUserRequest request, CancellationToken cancellationToken)
  {
    var user = await dbContext.Users.FirstOrDefaultAsync(x => x.Id == id, cancellationToken);
    if (user is null)
    {
      return NotFound(new { message = "User not found." });
    }

    if (!IsValidRole(request.Role))
    {
      return BadRequest(new { message = "Invalid role selected." });
    }

    var branch = await dbContext.Branches
      .FirstOrDefaultAsync(x => x.BranchCode == (request.BranchCode ?? string.Empty).Trim() && x.IsActive, cancellationToken);
    if (branch is null)
    {
      return BadRequest(new { message = "Please select a valid branch." });
    }

    user.FullName = (request.FullName ?? string.Empty).Trim();
    user.PhoneNumber = (request.PhoneNumber ?? string.Empty).Trim();
    user.BranchCode = branch.BranchCode;
    user.BranchName = branch.BranchName;
    user.Role = request.Role.Trim().ToUpperInvariant();
    user.IsActive = request.IsActive;

    await dbContext.SaveChangesAsync(cancellationToken);

    await auditService.LogAsync(
      GetCurrentUserId(),
      null,
      "UPDATE_USER",
      "AppUser",
      user.Id.ToString(),
      new { user.Username, user.Role, user.BranchCode, user.IsActive },
      HttpContext.Connection.RemoteIpAddress?.ToString(),
      cancellationToken
    );

    return Ok(MapUser(user));
  }

  [HttpPost("users/{id:guid}/reset-password")]
  public async Task<ActionResult<AdminUserListItemDto>> ResetPassword(Guid id, [FromBody] ResetUserPasswordRequest request, CancellationToken cancellationToken)
  {
    var user = await dbContext.Users.FirstOrDefaultAsync(x => x.Id == id, cancellationToken);
    if (user is null)
    {
      return NotFound(new { message = "User not found." });
    }

    if (string.IsNullOrWhiteSpace(request.NewPassword) || request.NewPassword.Trim().Length < 8)
    {
      return BadRequest(new { message = "New password must be at least 8 characters." });
    }

    passwordHasher.CreateHash(request.NewPassword.Trim(), out var hash, out var salt);
    user.PasswordHash = hash;
    user.PasswordSalt = salt;
    user.MustChangePassword = request.ForcePasswordChange;
    user.PasswordChangedAtUtc = request.ForcePasswordChange ? null : DateTime.UtcNow;

    await dbContext.SaveChangesAsync(cancellationToken);

    await auditService.LogAsync(
      GetCurrentUserId(),
      null,
      "RESET_USER_PASSWORD",
      "AppUser",
      user.Id.ToString(),
      new { user.Username, user.MustChangePassword },
      HttpContext.Connection.RemoteIpAddress?.ToString(),
      cancellationToken
    );

    return Ok(MapUser(user));
  }

  private static bool IsValidRole(string? role)
  {
    var value = (role ?? string.Empty).Trim().ToUpperInvariant();
    return AllowedRoles.Contains(value);
  }

  private Guid? GetCurrentUserId()
  {
    var raw = User.FindFirstValue(ClaimTypes.NameIdentifier);
    return Guid.TryParse(raw, out var userId) ? userId : null;
  }

  private static AdminUserListItemDto MapUser(AppUser user)
  {
    return new AdminUserListItemDto(
      user.Id,
      user.Username,
      user.FullName,
      user.PhoneNumber,
      user.BranchCode,
      user.BranchName,
      user.Role,
      user.IsActive,
      user.MustChangePassword,
      user.CreatedAtUtc,
      user.LastLoginAtUtc,
      user.PasswordChangedAtUtc
    );
  }
}
