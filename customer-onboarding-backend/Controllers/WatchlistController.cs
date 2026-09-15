using System.Security.Claims;
using CustomerOnboarding.Backend.Dtos;
using CustomerOnboarding.Backend.Models;
using CustomerOnboarding.Backend.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace CustomerOnboarding.Backend.Controllers;

[ApiController]
[Route("api/core/watchlist")]
[Authorize(Roles = $"{UserRoles.KycUnit},{UserRoles.Admin},{UserRoles.SystemAdmin}")]
public class WatchlistController(
  IWatchlistService watchlistService,
  IAuditService auditService
) : ControllerBase
{
  private const long MaximumImportSizeBytes = 10 * 1024 * 1024;

  [HttpGet]
  public async Task<ActionResult<WatchlistPagedResponseDto>> GetPaged(
    [FromQuery] WatchlistQueryDto query,
    CancellationToken cancellationToken)
  {
    return Ok(await watchlistService.GetPagedAsync(query, cancellationToken));
  }

  [HttpGet("{id}")]
  public async Task<ActionResult<WatchlistEntryDto>> GetById(string id, CancellationToken cancellationToken)
  {
    var entry = await watchlistService.GetByIdAsync(id, cancellationToken);
    return entry is null ? NotFound(new { message = "Watchlist entry was not found." }) : Ok(entry);
  }

  [HttpGet("import-template")]
  public IActionResult DownloadImportTemplate()
  {
    var template = watchlistService.BuildImportTemplate();
    return File(template,
      "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
      "watchlist-import-template.xlsx");
  }

  [HttpPost]
  public async Task<ActionResult<WatchlistEntryDto>> Create(
    [FromBody] UpsertWatchlistEntryRequest request,
    CancellationToken cancellationToken)
  {
    try
    {
      var entry = await watchlistService.CreateAsync(request, GetCurrentUserName(), cancellationToken);
      await auditService.LogAsync(
        GetCurrentUserId(), null, "CREATE_WATCHLIST_ENTRY", "WatchlistEntry", entry.Id,
        new { entry.FullName, entry.ScreeningCategory, entry.SourceList, entry.SourceReference },
        HttpContext.Connection.RemoteIpAddress?.ToString(), cancellationToken);
      return CreatedAtAction(nameof(GetById), new { id = entry.Id }, entry);
    }
    catch (InvalidOperationException ex)
    {
      return BadRequest(new { message = ex.Message });
    }
  }

  [HttpPut("{id}")]
  public async Task<ActionResult<WatchlistEntryDto>> Update(
    string id,
    [FromBody] UpsertWatchlistEntryRequest request,
    CancellationToken cancellationToken)
  {
    try
    {
      var entry = await watchlistService.UpdateAsync(id, request, GetCurrentUserName(), cancellationToken);
      if (entry is null)
      {
        return NotFound(new { message = "Watchlist entry was not found." });
      }

      await auditService.LogAsync(
        GetCurrentUserId(), null, "UPDATE_WATCHLIST_ENTRY", "WatchlistEntry", entry.Id,
        new { entry.FullName, entry.ScreeningCategory, entry.SourceList, entry.SourceReference, entry.IsActive },
        HttpContext.Connection.RemoteIpAddress?.ToString(), cancellationToken);
      return Ok(entry);
    }
    catch (InvalidOperationException ex)
    {
      return BadRequest(new { message = ex.Message });
    }
  }

  [HttpDelete("{id}")]
  public async Task<IActionResult> Delete(string id, CancellationToken cancellationToken)
  {
    var entry = await watchlistService.GetByIdAsync(id, cancellationToken);
    if (entry is null)
    {
      return NotFound(new { message = "Watchlist entry was not found." });
    }

    if (!await watchlistService.DeleteAsync(id, cancellationToken))
    {
      return NotFound(new { message = "Watchlist entry was not found." });
    }

    await auditService.LogAsync(
      GetCurrentUserId(), null, "DELETE_WATCHLIST_ENTRY", "WatchlistEntry", entry.Id,
      new { entry.FullName, entry.ScreeningCategory, entry.SourceList, entry.SourceReference },
      HttpContext.Connection.RemoteIpAddress?.ToString(), cancellationToken);
    return NoContent();
  }

  [HttpPost("import")]
  [RequestSizeLimit(MaximumImportSizeBytes)]
  public async Task<ActionResult<WatchlistImportResultDto>> Import(
    [FromForm] IFormFile? file,
    CancellationToken cancellationToken)
  {
    if (file is null || file.Length == 0)
    {
      return BadRequest(new { message = "Select a watchlist Excel file to import." });
    }

    if (file.Length > MaximumImportSizeBytes)
    {
      return BadRequest(new { message = "The watchlist file must not exceed 10 MB." });
    }

    var extension = Path.GetExtension(file.FileName);
    if (!string.Equals(extension, ".xlsx", StringComparison.OrdinalIgnoreCase) &&
        !string.Equals(extension, ".xlsm", StringComparison.OrdinalIgnoreCase))
    {
      return BadRequest(new { message = "Upload an .xlsx or .xlsm watchlist workbook." });
    }

    try
    {
      await using var stream = file.OpenReadStream();
      var result = await watchlistService.ImportAsync(stream, file.FileName, GetCurrentUserName(), cancellationToken);
      if (result.Errors.Count > 0)
      {
        return BadRequest(new
        {
          message = "Import validation failed. No watchlist entries were changed.",
          result
        });
      }

      await auditService.LogAsync(
        GetCurrentUserId(), null, "IMPORT_WATCHLIST_ENTRIES", "WatchlistEntry", file.FileName,
        new { result.WorksheetName, result.ProcessedRows, result.InsertedRows, result.UpdatedRows, result.SkippedBlankRows },
        HttpContext.Connection.RemoteIpAddress?.ToString(), cancellationToken);
      return Ok(result);
    }
    catch (InvalidOperationException ex)
    {
      return BadRequest(new { message = ex.Message });
    }
    catch (Exception)
    {
      return StatusCode(500, new { message = "The watchlist workbook could not be imported. Confirm that it is a valid Excel file and try again." });
    }
  }

  private Guid? GetCurrentUserId()
  {
    return Guid.TryParse(User.FindFirstValue(ClaimTypes.NameIdentifier), out var userId) ? userId : null;
  }

  private string GetCurrentUserName() => User.Identity?.Name?.Trim() ?? "Unknown";
}
