using System.Security.Claims;
using System.Text.RegularExpressions;
using CustomerOnboarding.Backend.Data;
using CustomerOnboarding.Backend.Dtos;
using CustomerOnboarding.Backend.Models;
using CustomerOnboarding.Backend.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace CustomerOnboarding.Backend.Controllers;

[ApiController]
[Route("api/core/admin/permissions")]
[Authorize(Roles = UserRoles.Admin + "," + UserRoles.SystemAdmin)]
public class PermissionManagementController(
  AppDbContext dbContext,
  IAuditService auditService
) : ControllerBase
{
  [HttpGet]
  public async Task<ActionResult<PermissionManagementSnapshotDto>> GetConfiguration(CancellationToken cancellationToken)
  {
    var permissions = await dbContext.SystemPermissions
      .AsNoTracking()
      .OrderBy(x => x.Name)
      .ToListAsync(cancellationToken);

    var assignments = await dbContext.RolePermissions
      .AsNoTracking()
      .Include(x => x.Permission)
      .ToListAsync(cancellationToken);

    var permissionDtos = permissions
      .Select(permission => new SystemPermissionDto(
        permission.Id,
        permission.Code,
        permission.Name,
        permission.Description,
        permission.IsActive,
        permission.CreatedAtUtc,
        permission.UpdatedAtUtc,
        assignments
          .Where(assignment => assignment.PermissionId == permission.Id)
          .Select(assignment => assignment.Role)
          .OrderBy(role => role)
          .ToList()
      ))
      .ToList();

    var roleDtos = UserRoles.All
      .OrderBy(role => role)
      .Select(role => new RolePermissionAssignmentDto(
        role,
        assignments
          .Where(assignment => assignment.Role == role && assignment.Permission.IsActive)
          .Select(assignment => assignment.Permission.Code)
          .OrderBy(code => code)
          .ToList()
      ))
      .ToList();

    return Ok(new PermissionManagementSnapshotDto(permissionDtos, roleDtos));
  }

  [HttpPost]
  public async Task<ActionResult<SystemPermissionDto>> CreatePermission(
    [FromBody] CreateSystemPermissionRequest request,
    CancellationToken cancellationToken)
  {
    var code = NormalizeCode(request.Code);
    var name = (request.Name ?? string.Empty).Trim();
    var validationMessage = ValidatePermission(code, name);
    if (validationMessage is not null)
    {
      return BadRequest(new { message = validationMessage });
    }

    var exists = await dbContext.SystemPermissions.AnyAsync(x => x.Code == code, cancellationToken);
    if (exists)
    {
      return Conflict(new { message = $"Permission {code} already exists." });
    }

    var now = DateTimeOffset.UtcNow;
    var permission = new SystemPermission
    {
      Code = code,
      Name = name,
      Description = TrimToNull(request.Description, 500),
      IsActive = request.IsActive,
      CreatedAtUtc = now,
      UpdatedAtUtc = now
    };

    dbContext.SystemPermissions.Add(permission);
    await dbContext.SaveChangesAsync(cancellationToken);

    await auditService.LogAsync(
      GetCurrentUserId(),
      null,
      "CREATE_SYSTEM_PERMISSION",
      "SystemPermission",
      permission.Id.ToString(),
      new { permission.Code, permission.Name, permission.IsActive },
      HttpContext.Connection.RemoteIpAddress?.ToString(),
      cancellationToken
    );

    return Created($"/api/core/admin/permissions/{permission.Id}", Map(permission, []));
  }

  [HttpPut("{id:int}")]
  public async Task<ActionResult<SystemPermissionDto>> UpdatePermission(
    int id,
    [FromBody] UpdateSystemPermissionRequest request,
    CancellationToken cancellationToken)
  {
    var permission = await dbContext.SystemPermissions.FirstOrDefaultAsync(x => x.Id == id, cancellationToken);
    if (permission is null)
    {
      return NotFound(new { message = "Permission was not found." });
    }

    var name = (request.Name ?? string.Empty).Trim();
    if (name.Length is < 3 or > 160)
    {
      return BadRequest(new { message = "Permission name must contain between 3 and 160 characters." });
    }

    permission.Name = name;
    permission.Description = TrimToNull(request.Description, 500);
    permission.IsActive = request.IsActive;
    permission.UpdatedAtUtc = DateTimeOffset.UtcNow;
    await dbContext.SaveChangesAsync(cancellationToken);

    var assignedRoles = await dbContext.RolePermissions
      .Where(x => x.PermissionId == permission.Id)
      .Select(x => x.Role)
      .OrderBy(role => role)
      .ToListAsync(cancellationToken);

    await auditService.LogAsync(
      GetCurrentUserId(),
      null,
      "UPDATE_SYSTEM_PERMISSION",
      "SystemPermission",
      permission.Id.ToString(),
      new { permission.Code, permission.Name, permission.IsActive },
      HttpContext.Connection.RemoteIpAddress?.ToString(),
      cancellationToken
    );

    return Ok(Map(permission, assignedRoles));
  }

  [HttpDelete("{id:int}")]
  public async Task<IActionResult> DeletePermission(int id, CancellationToken cancellationToken)
  {
    var permission = await dbContext.SystemPermissions.FirstOrDefaultAsync(x => x.Id == id, cancellationToken);
    if (permission is null)
    {
      return NotFound(new { message = "Permission was not found." });
    }

    var assignmentCount = await dbContext.RolePermissions.CountAsync(x => x.PermissionId == id, cancellationToken);
    if (assignmentCount > 0)
    {
      return Conflict(new { message = "Remove this permission from its assigned roles before deleting it." });
    }

    dbContext.SystemPermissions.Remove(permission);
    await dbContext.SaveChangesAsync(cancellationToken);

    await auditService.LogAsync(
      GetCurrentUserId(),
      null,
      "DELETE_SYSTEM_PERMISSION",
      "SystemPermission",
      id.ToString(),
      new { permission.Code, permission.Name },
      HttpContext.Connection.RemoteIpAddress?.ToString(),
      cancellationToken
    );

    return NoContent();
  }

  [HttpPut("roles/{role}/assignments")]
  public async Task<ActionResult<RolePermissionAssignmentDto>> UpdateRoleAssignments(
    string role,
    [FromBody] UpdateRolePermissionsRequest request,
    CancellationToken cancellationToken)
  {
    var normalizedRole = (role ?? string.Empty).Trim().ToUpperInvariant();
    if (!UserRoles.All.Contains(normalizedRole, StringComparer.OrdinalIgnoreCase))
    {
      return BadRequest(new { message = "Select a valid application role." });
    }

    var requestedCodes = (request.PermissionCodes ?? [])
      .Select(NormalizeCode)
      .Where(code => !string.IsNullOrWhiteSpace(code))
      .Distinct(StringComparer.OrdinalIgnoreCase)
      .ToList();

    var permissions = await dbContext.SystemPermissions
      .Where(x => requestedCodes.Contains(x.Code) && x.IsActive)
      .ToListAsync(cancellationToken);

    if (permissions.Count != requestedCodes.Count)
    {
      return BadRequest(new { message = "One or more selected permissions are inactive or unavailable." });
    }

    var existingAssignments = await dbContext.RolePermissions
      .Where(x => x.Role == normalizedRole)
      .ToListAsync(cancellationToken);

    dbContext.RolePermissions.RemoveRange(existingAssignments);
    var assignedBy = User.Identity?.Name?.Trim() ?? "system";
    var assignedAt = DateTimeOffset.UtcNow;
    dbContext.RolePermissions.AddRange(permissions.Select(permission => new RolePermission
    {
      Role = normalizedRole,
      PermissionId = permission.Id,
      AssignedAtUtc = assignedAt,
      AssignedByUserName = assignedBy
    }));
    await dbContext.SaveChangesAsync(cancellationToken);

    await auditService.LogAsync(
      GetCurrentUserId(),
      null,
      "UPDATE_ROLE_PERMISSIONS",
      "RolePermission",
      normalizedRole,
      new { Role = normalizedRole, PermissionCodes = requestedCodes },
      HttpContext.Connection.RemoteIpAddress?.ToString(),
      cancellationToken
    );

    return Ok(new RolePermissionAssignmentDto(normalizedRole, requestedCodes.OrderBy(code => code).ToList()));
  }

  private Guid? GetCurrentUserId()
  {
    var rawUserId = User.FindFirstValue(ClaimTypes.NameIdentifier);
    return Guid.TryParse(rawUserId, out var userId) ? userId : null;
  }

  private static SystemPermissionDto Map(SystemPermission permission, IReadOnlyList<string> assignedRoles) => new(
    permission.Id,
    permission.Code,
    permission.Name,
    permission.Description,
    permission.IsActive,
    permission.CreatedAtUtc,
    permission.UpdatedAtUtc,
    assignedRoles
  );

  private static string NormalizeCode(string? code) => (code ?? string.Empty).Trim().ToUpperInvariant();

  private static string? ValidatePermission(string code, string name)
  {
    if (!Regex.IsMatch(code, "^[A-Z][A-Z0-9_]{2,63}$"))
    {
      return "Permission code must use 3 to 64 uppercase letters, numbers, or underscores.";
    }

    if (name.Length is < 3 or > 160)
    {
      return "Permission name must contain between 3 and 160 characters.";
    }

    return null;
  }

  private static string? TrimToNull(string? value, int maximumLength)
  {
    var trimmed = (value ?? string.Empty).Trim();
    return string.IsNullOrWhiteSpace(trimmed) ? null : trimmed[..Math.Min(trimmed.Length, maximumLength)];
  }
}
