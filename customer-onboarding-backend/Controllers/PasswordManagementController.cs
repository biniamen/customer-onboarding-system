using System.Security.Claims;
using CustomerOnboarding.Backend.Dtos;
using CustomerOnboarding.Backend.Models;
using CustomerOnboarding.Backend.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace CustomerOnboarding.Backend.Controllers;

[ApiController]
[Route("api/core/password-management")]
[Authorize(Roles = UserRoles.Admin)]
public class PasswordManagementController(
  IPasswordManagementService passwordManagementService,
  IAuditService auditService
) : ControllerBase
{
  [HttpGet("external-users")]
  public async Task<ActionResult<IReadOnlyList<ExternalDirectoryUserDto>>> GetExternalUsers([FromQuery] string? search, [FromQuery] int limit = 20, CancellationToken cancellationToken = default)
  {
    var users = await passwordManagementService.GetExternalUsersAsync(search, limit, cancellationToken);
    return Ok(users);
  }

  [HttpGet("templates")]
  public async Task<ActionResult<IReadOnlyList<PasswordMessageTemplateDto>>> GetTemplates(CancellationToken cancellationToken)
  {
    var templates = await passwordManagementService.GetTemplatesAsync(cancellationToken);
    return Ok(templates);
  }

  [HttpPut("templates/{templateType}")]
  public async Task<ActionResult<PasswordMessageTemplateDto>> SaveTemplate(string templateType, [FromBody] UpdatePasswordMessageTemplateRequest request, CancellationToken cancellationToken)
  {
    if (string.IsNullOrWhiteSpace(request.Title))
    {
      return BadRequest(new { message = "Template title is required." });
    }

    if (string.IsNullOrWhiteSpace(request.Body))
    {
      return BadRequest(new { message = "Template body is required." });
    }

    try
    {
      var currentUserName = User.FindFirstValue(ClaimTypes.Name) ?? User.Identity?.Name ?? "system";
      var template = await passwordManagementService.SaveTemplateAsync(templateType, request, currentUserName, cancellationToken);

      await auditService.LogAsync(
        GetCurrentUserId(),
        null,
        "UPDATE_PASSWORD_SMS_TEMPLATE",
        "PasswordMessageTemplate",
        template.TemplateType,
        new { template.TemplateType, template.Title, template.IsActive },
        HttpContext.Connection.RemoteIpAddress?.ToString(),
        cancellationToken
      );

      return Ok(template);
    }
    catch (InvalidOperationException ex)
    {
      return BadRequest(new { message = ex.Message });
    }
  }

  [HttpPost("send-reset-sms")]
  public async Task<ActionResult<PasswordMessageDispatchResultDto>> SendResetSms([FromBody] SendPasswordResetSmsRequest request, CancellationToken cancellationToken)
  {
    if (string.IsNullOrWhiteSpace(request.ExternalUserId))
    {
      return BadRequest(new { message = "Please select a user." });
    }

    if (string.IsNullOrWhiteSpace(request.Password) || request.Password.Trim().Length < 8)
    {
      return BadRequest(new { message = "Password must be at least 8 characters." });
    }

    try
    {
      var currentUserName = User.FindFirstValue(ClaimTypes.Name) ?? User.Identity?.Name ?? "system";
      var result = await passwordManagementService.SendPasswordResetSmsAsync(request, currentUserName, cancellationToken);

      await auditService.LogAsync(
        GetCurrentUserId(),
        null,
        "SEND_PASSWORD_RESET_SMS",
        "ExternalDirectoryUser",
        result.ExternalUserId,
        new { result.FullEmployeeName, result.PhoneNumber, result.Sent },
        HttpContext.Connection.RemoteIpAddress?.ToString(),
        cancellationToken
      );

      return result.Sent
        ? Ok(result)
        : StatusCode(502, result);
    }
    catch (InvalidOperationException ex)
    {
      return BadRequest(new { message = ex.Message });
    }
  }

  [HttpPost("send-new-user-sms")]
  public async Task<ActionResult<PasswordMessageDispatchResultDto>> SendNewUserSms([FromBody] SendNewUserCredentialSmsRequest request, CancellationToken cancellationToken)
  {
    if (string.IsNullOrWhiteSpace(request.ExternalUserId))
    {
      return BadRequest(new { message = "Please select a user." });
    }

    if (string.IsNullOrWhiteSpace(request.Username) || request.Username.Trim().Length < 3)
    {
      return BadRequest(new { message = "Username must be at least 3 characters." });
    }

    if (string.IsNullOrWhiteSpace(request.Password) || request.Password.Trim().Length < 8)
    {
      return BadRequest(new { message = "Password must be at least 8 characters." });
    }

    try
    {
      var currentUserName = User.FindFirstValue(ClaimTypes.Name) ?? User.Identity?.Name ?? "system";
      var result = await passwordManagementService.SendNewUserCredentialSmsAsync(request, currentUserName, cancellationToken);

      await auditService.LogAsync(
        GetCurrentUserId(),
        null,
        "SEND_NEW_USER_CREDENTIAL_SMS",
        "ExternalDirectoryUser",
        result.ExternalUserId,
        new { result.FullEmployeeName, result.PhoneNumber, Username = request.Username, result.Sent },
        HttpContext.Connection.RemoteIpAddress?.ToString(),
        cancellationToken
      );

      return result.Sent
        ? Ok(result)
        : StatusCode(502, result);
    }
    catch (InvalidOperationException ex)
    {
      return BadRequest(new { message = ex.Message });
    }
  }

  private Guid? GetCurrentUserId()
  {
    var raw = User.FindFirstValue(ClaimTypes.NameIdentifier);
    return Guid.TryParse(raw, out var userId) ? userId : null;
  }
}
