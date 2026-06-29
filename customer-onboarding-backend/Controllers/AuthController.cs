using System.Security.Claims;
using CustomerOnboarding.Backend.Data;
using CustomerOnboarding.Backend.Dtos;
using CustomerOnboarding.Backend.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace CustomerOnboarding.Backend.Controllers;

[ApiController]
[Route("api/core/auth")]
public class AuthController(
  AppDbContext dbContext,
  IPasswordHasher passwordHasher,
  ITokenService tokenService,
  IAuditService auditService
) : ControllerBase
{
  [HttpPost("login")]
  [AllowAnonymous]
  public async Task<ActionResult<LoginResponse>> Login([FromBody] LoginRequest request, CancellationToken cancellationToken)
  {
    var username = request.Username.Trim();
    var user = await dbContext.Users.FirstOrDefaultAsync(x => x.Username == username, cancellationToken);
    if (user is null || !user.IsActive || !passwordHasher.Verify(request.Password, user.PasswordHash, user.PasswordSalt))
    {
      return Unauthorized(new { message = "Invalid username or password." });
    }

    user.LastLoginAtUtc = DateTime.UtcNow;
    await dbContext.SaveChangesAsync(cancellationToken);

    var token = tokenService.CreateToken(user, out var expiresAtUtc);
    await auditService.LogAsync(user.Id, null, "LOGIN_SUCCESS", "AppUser", user.Id.ToString(), new { user.Username, user.Role }, HttpContext.Connection.RemoteIpAddress?.ToString(), cancellationToken);

    return Ok(new LoginResponse(
      token,
      expiresAtUtc,
      new UserProfileDto(user.Id, user.Username, user.FullName, user.PhoneNumber, user.BranchCode, user.BranchName, user.Role, user.MustChangePassword)
    ));
  }

  [HttpGet("me")]
  [Authorize]
  public async Task<ActionResult<UserProfileDto>> Me(CancellationToken cancellationToken)
  {
    var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
    if (!Guid.TryParse(userId, out var parsedUserId))
    {
      return Unauthorized();
    }

    var user = await dbContext.Users.FirstOrDefaultAsync(x => x.Id == parsedUserId, cancellationToken);
    if (user is null)
    {
      return Unauthorized();
    }

    return Ok(new UserProfileDto(user.Id, user.Username, user.FullName, user.PhoneNumber, user.BranchCode, user.BranchName, user.Role, user.MustChangePassword));
  }

  [HttpPost("change-password")]
  [Authorize]
  public async Task<ActionResult<UserProfileDto>> ChangePassword([FromBody] ChangePasswordRequest request, CancellationToken cancellationToken)
  {
    var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
    if (!Guid.TryParse(userId, out var parsedUserId))
    {
      return Unauthorized();
    }

    var user = await dbContext.Users.FirstOrDefaultAsync(x => x.Id == parsedUserId, cancellationToken);
    if (user is null || !user.IsActive)
    {
      return Unauthorized();
    }

    if (string.IsNullOrWhiteSpace(request.NewPassword) || request.NewPassword.Trim().Length < 8)
    {
      return BadRequest(new { message = "New password must be at least 8 characters." });
    }

    if (!passwordHasher.Verify(request.CurrentPassword, user.PasswordHash, user.PasswordSalt))
    {
      return BadRequest(new { message = "Current password is not valid." });
    }

    if (request.CurrentPassword == request.NewPassword)
    {
      return BadRequest(new { message = "New password must be different from current password." });
    }

    passwordHasher.CreateHash(request.NewPassword.Trim(), out var hash, out var salt);
    user.PasswordHash = hash;
    user.PasswordSalt = salt;
    user.MustChangePassword = false;
    user.PasswordChangedAtUtc = DateTime.UtcNow;

    await dbContext.SaveChangesAsync(cancellationToken);

    await auditService.LogAsync(
      user.Id,
      null,
      "CHANGE_PASSWORD",
      "AppUser",
      user.Id.ToString(),
      new { user.Username, Enforced = false },
      HttpContext.Connection.RemoteIpAddress?.ToString(),
      cancellationToken
    );

    return Ok(new UserProfileDto(user.Id, user.Username, user.FullName, user.PhoneNumber, user.BranchCode, user.BranchName, user.Role, user.MustChangePassword));
  }
}
