using System.Text.Json;
using CustomerOnboarding.Backend.Data;
using CustomerOnboarding.Backend.Dtos;
using CustomerOnboarding.Backend.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace CustomerOnboarding.Backend.Controllers;

[ApiController]
[Route("api/core/audit-logs")]
[Authorize(Roles = $"{UserRoles.Admin},{UserRoles.SystemAdmin}")]
public class AuditLogsController(AppDbContext dbContext) : ControllerBase
{
  private static readonly string[] PasswordActions =
  [
    "SEND_PASSWORD_RESET_SMS",
    "SEND_NEW_USER_CREDENTIAL_SMS"
  ];

  [HttpGet("password-messages")]
  public async Task<ActionResult<PasswordMessageAuditLogResponseDto>> GetPasswordMessageAuditLogs(
    [FromQuery] PasswordMessageAuditLogQueryDto query,
    CancellationToken cancellationToken)
  {
    var logs = dbContext.AuditLogs
      .AsNoTracking()
      .Include(x => x.User)
      .Where(x => PasswordActions.Contains(x.Action));

    if (query.FromDate.HasValue)
    {
      logs = logs.Where(x => x.CreatedAtUtc >= query.FromDate.Value.UtcDateTime);
    }

    if (query.ToDate.HasValue)
    {
      logs = logs.Where(x => x.CreatedAtUtc <= query.ToDate.Value.UtcDateTime);
    }

    if (!string.IsNullOrWhiteSpace(query.Search))
    {
      var keyword = $"%{query.Search.Trim()}%";
      logs = logs.Where(x =>
        EF.Functions.ILike(x.Action, keyword) ||
        EF.Functions.ILike(x.IpAddress ?? string.Empty, keyword) ||
        EF.Functions.ILike(x.DetailsJson ?? string.Empty, keyword) ||
        (x.User != null && (
          EF.Functions.ILike(x.User.Username ?? string.Empty, keyword) ||
          EF.Functions.ILike(x.User.FullName ?? string.Empty, keyword))));
    }

    logs = logs.OrderByDescending(x => x.CreatedAtUtc);

    var totalRecords = await logs.CountAsync(cancellationToken);
    var pageSize = query.PageSize == -1 ? int.MaxValue : (query.PageSize <= 0 ? 20 : query.PageSize);
    var page = query.Page <= 0 ? 1 : query.Page;

    List<AuditLog> rows;
    var totalPages = 1;

    if (pageSize == int.MaxValue)
    {
      rows = await logs.ToListAsync(cancellationToken);
      page = 1;
    }
    else
    {
      totalPages = Math.Max(1, (int)Math.Ceiling(totalRecords / (double)pageSize));
      page = Math.Min(page, totalPages);
      var skip = (page - 1) * pageSize;
      rows = await logs.Skip(skip).Take(pageSize).ToListAsync(cancellationToken);
    }

    return Ok(new PasswordMessageAuditLogResponseDto(
      page,
      pageSize,
      totalRecords,
      totalPages,
      rows.Select(Map).ToList()
    ));
  }

  private static PasswordMessageAuditLogDto Map(AuditLog log)
  {
    string? recipientFullEmployeeName = null;
    string? recipientPhoneNumber = null;
    string? systemName = null;
    string? provisionedUsername = null;
    bool? sent = null;

    if (!string.IsNullOrWhiteSpace(log.DetailsJson))
    {
      try
      {
        using var document = JsonDocument.Parse(log.DetailsJson);
        var root = document.RootElement;

        recipientFullEmployeeName = ReadString(root, "FullEmployeeName");
        recipientPhoneNumber = ReadString(root, "PhoneNumber");
        systemName = ReadString(root, "SystemName");
        provisionedUsername = ReadString(root, "Username");
        sent = ReadBoolean(root, "Sent");
      }
      catch
      {
        // ignore malformed audit payloads and return the row metadata we still have
      }
    }

    return new PasswordMessageAuditLogDto(
      log.Id,
      log.Action,
      log.User?.Username,
      log.User?.FullName,
      recipientFullEmployeeName,
      recipientPhoneNumber,
      systemName,
      provisionedUsername,
      sent,
      log.IpAddress,
      DateTime.SpecifyKind(log.CreatedAtUtc, DateTimeKind.Utc)
    );
  }

  private static string? ReadString(JsonElement element, string propertyName)
  {
    return element.TryGetProperty(propertyName, out var value)
      ? value.GetString()
      : null;
  }

  private static bool? ReadBoolean(JsonElement element, string propertyName)
  {
    if (!element.TryGetProperty(propertyName, out var value))
    {
      return null;
    }

    return value.ValueKind switch
    {
      JsonValueKind.True => true,
      JsonValueKind.False => false,
      _ when bool.TryParse(value.ToString(), out var parsed) => parsed,
      _ => null
    };
  }
}
