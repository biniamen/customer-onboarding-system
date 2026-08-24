using System.Security.Claims;
using System.Text.Json;
using CustomerOnboarding.Backend.Data;
using CustomerOnboarding.Backend.Dtos;
using CustomerOnboarding.Backend.Models;
using CustomerOnboarding.Backend.Options;
using CustomerOnboarding.Backend.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;

namespace CustomerOnboarding.Backend.Controllers;

[ApiController]
[Route("api/core/bsa")]
[Authorize(Roles = UserRoles.Admin + "," + UserRoles.SystemAdmin)]
public class BsaController(
  AppDbContext dbContext,
  IBsaIntegrationService bsaIntegrationService,
  IAuditService auditService,
  IOptions<BsaOptions> bsaOptions
) : ControllerBase
{
  private readonly BsaOptions _bsaOptions = bsaOptions.Value;

  [HttpPost("login")]
  public async Task<ActionResult<BsaConnectionResultDto>> Login([FromBody] BsaLoginRequestDto? request, CancellationToken cancellationToken)
  {
    var result = await bsaIntegrationService.AuthenticateAsync(request?.Username, request?.Password, cancellationToken);
    await LogAuditAsync(
      "BSA_LOGIN_CHECK",
      "BsaConnection",
      request?.Username?.Trim() ?? _bsaOptions.Username,
      new { result.Success, result.Authenticated, result.Message, result.ErrorCode },
      cancellationToken
    );

    return Ok(new BsaConnectionResultDto(
      result.Success,
      result.Message,
      result.Authenticated,
      result.ErrorCode,
      result.RawResponse
    ));
  }

  [HttpGet("return-dictionary")]
  public async Task<ActionResult<BsaReturnDictionaryResponseDto>> GetReturnDictionary([FromQuery] string returnKey, CancellationToken cancellationToken)
  {
    var normalizedReturnKey = (returnKey ?? string.Empty).Trim();
    if (string.IsNullOrWhiteSpace(normalizedReturnKey))
    {
      return BadRequest(new { message = "returnKey is required." });
    }

    var result = await bsaIntegrationService.GetReturnDictionaryAsync(normalizedReturnKey, cancellationToken);
    await LogAuditAsync(
      "BSA_RETURN_DICTIONARY",
      "BsaReturnDictionary",
      normalizedReturnKey,
      new { result.Success, result.Message },
      cancellationToken
    );

    return Ok(new BsaReturnDictionaryResponseDto(result.Success, result.Message, result.Dictionary, result.RawResponse));
  }

  [HttpPost("submit")]
  public async Task<ActionResult<BsaSubmissionResultDto>> Submit([FromBody] SubmitBsaReturnRequestDto request, CancellationToken cancellationToken)
  {
    var validationMessage = ValidateSubmissionRequest(request);
    if (!string.IsNullOrWhiteSpace(validationMessage))
    {
      return BadRequest(new { message = validationMessage });
    }

    var currentUser = await GetCurrentUserAsync(cancellationToken);
    var payload = MapSubmissionPayload(request);
    var requestPayload = JsonSerializer.Serialize(payload);
    var gatewayResult = await bsaIntegrationService.SubmitAsync(payload, cancellationToken);

    var record = new BsaSubmissionRecord
    {
      SubmissionReference = BuildSubmissionReference(),
      ReturnKey = payload.ReturnKey,
      InstitutionCode = payload.InstCode,
      FinancialYear = payload.FinYear,
      PeriodStart = payload.StartDate,
      PeriodEnd = payload.EndDate,
      BsaFileName = gatewayResult.Submission?.FileName,
      SubmissionStatus = ResolveSubmissionStatus(gatewayResult, gatewayResult.Submission),
      Notification = gatewayResult.Submission?.Status,
      LastProcessingStatus = gatewayResult.Submission?.Status,
      CreatedByUserName = currentUser.Username,
      CreatedByBranchCode = currentUser.BranchCode,
      CreatedAt = DateTimeOffset.UtcNow,
      UpdatedAt = DateTimeOffset.UtcNow,
      SubmittedAt = gatewayResult.Success ? DateTimeOffset.UtcNow : null,
      CompletedAt = gatewayResult.Success && IsCompletedStatus(gatewayResult.Submission?.Status) ? DateTimeOffset.UtcNow : null,
      RequestPayload = requestPayload,
      SubmissionResponsePayload = gatewayResult.RawResponse,
      ErrorMessage = gatewayResult.Success ? null : gatewayResult.Message
    };

    dbContext.BsaSubmissionRecords.Add(record);
    await dbContext.SaveChangesAsync(cancellationToken);

    await auditService.LogAsync(
      currentUser.Id,
      null,
      "BSA_SUBMIT",
      "BsaSubmissionRecord",
      record.Id.ToString(),
      new { record.SubmissionReference, record.ReturnKey, record.BsaFileName, record.SubmissionStatus, gatewayResult.Message },
      HttpContext.Connection.RemoteIpAddress?.ToString(),
      cancellationToken
    );

    var resultDto = new BsaSubmissionResultDto(
      gatewayResult.Success,
      gatewayResult.Message,
      Map(record),
      gatewayResult.Submission,
      gatewayResult.RawResponse
    );

    return Ok(resultDto);
  }

  [HttpGet("status")]
  public async Task<ActionResult<BsaStatusResultDto>> GetStatus([FromQuery] string? fileName, [FromQuery] int? submissionId, CancellationToken cancellationToken)
  {
    var normalizedFileName = (fileName ?? string.Empty).Trim();
    BsaSubmissionRecord? record = null;

    if (submissionId.HasValue)
    {
      record = await dbContext.BsaSubmissionRecords.FirstOrDefaultAsync(x => x.Id == submissionId.Value, cancellationToken);
      if (record is null)
      {
        return NotFound(new { message = "BSA submission record was not found." });
      }

      normalizedFileName = string.IsNullOrWhiteSpace(normalizedFileName) ? record.BsaFileName ?? string.Empty : normalizedFileName;
    }
    else if (!string.IsNullOrWhiteSpace(normalizedFileName))
    {
      record = await dbContext.BsaSubmissionRecords
        .OrderByDescending(x => x.CreatedAt)
        .FirstOrDefaultAsync(x => x.BsaFileName == normalizedFileName, cancellationToken);
    }

    if (string.IsNullOrWhiteSpace(normalizedFileName))
    {
      return BadRequest(new { message = "fileName or submissionId is required." });
    }

    var gatewayResult = await bsaIntegrationService.GetStatusAsync(normalizedFileName, cancellationToken);

    if (record is not null)
    {
      record.StatusResponsePayload = gatewayResult.RawResponse;
      record.LastStatusCheckedAt = DateTimeOffset.UtcNow;
      record.UpdatedAt = DateTimeOffset.UtcNow;
      record.Notification = gatewayResult.Status?.Notification;
      record.LastProcessingStatus = ResolveProcessingStatus(gatewayResult.Status);
      record.SubmissionStatus = ResolveSubmissionStatusFromStatus(gatewayResult);
      record.ErrorMessage = gatewayResult.Success ? record.ErrorMessage : gatewayResult.Message;

      if (record.SubmissionStatus is BsaSubmissionStatuses.ProcessedSuccessfully or BsaSubmissionStatuses.ProcessingFailed or BsaSubmissionStatuses.Discarded)
      {
        record.CompletedAt ??= DateTimeOffset.UtcNow;
      }

      await dbContext.SaveChangesAsync(cancellationToken);
    }

    await LogAuditAsync(
      "BSA_STATUS_CHECK",
      "BsaSubmissionRecord",
      submissionId?.ToString() ?? normalizedFileName,
      new { gatewayResult.Success, gatewayResult.Message, FileName = normalizedFileName },
      cancellationToken
    );

    return Ok(new BsaStatusResultDto(
      gatewayResult.Success,
      gatewayResult.Message,
      gatewayResult.Status,
      record is null ? null : Map(record),
      gatewayResult.RawResponse
    ));
  }

  [HttpPost("discard-last-partial")]
  public async Task<ActionResult<BsaDiscardResultDto>> DiscardLastPartial([FromBody] BsaDiscardRequestDto request, CancellationToken cancellationToken)
  {
    if (string.IsNullOrWhiteSpace(request.ReturnKey))
    {
      return BadRequest(new { message = "ReturnKey is required." });
    }

    if (request.FinancialYear <= 2007)
    {
      return BadRequest(new { message = "FinancialYear must be greater than 2007." });
    }

    request.ReturnKey = request.ReturnKey.Trim();
    request.InstitutionCode = ResolveInstitutionCode(request.InstitutionCode);
    var requestPayload = JsonSerializer.Serialize(request);
    var gatewayResult = await bsaIntegrationService.DiscardLastPartialSubmissionAsync(request, cancellationToken);

    var record = await dbContext.BsaSubmissionRecords
      .Where(x =>
        x.ReturnKey == request.ReturnKey &&
        x.InstitutionCode == request.InstitutionCode &&
        x.FinancialYear == request.FinancialYear &&
        x.PeriodStart == request.StartDate &&
        x.PeriodEnd == request.EndDate)
      .OrderByDescending(x => x.CreatedAt)
      .FirstOrDefaultAsync(cancellationToken);

    if (record is not null)
    {
      record.DiscardRequestPayload = requestPayload;
      record.DiscardResponsePayload = gatewayResult.RawResponse;
      record.UpdatedAt = DateTimeOffset.UtcNow;
      if (gatewayResult.Success)
      {
        record.SubmissionStatus = BsaSubmissionStatuses.Discarded;
        record.CompletedAt = DateTimeOffset.UtcNow;
        record.ErrorMessage = null;
      }
      else
      {
        record.ErrorMessage = gatewayResult.Message;
      }

      await dbContext.SaveChangesAsync(cancellationToken);
    }

    await LogAuditAsync(
      "BSA_DISCARD_LAST_PARTIAL",
      "BsaSubmissionRecord",
      record?.Id.ToString() ?? request.ReturnKey,
      new { gatewayResult.Success, gatewayResult.Message, request.ReturnKey, request.InstitutionCode, request.FinancialYear },
      cancellationToken
    );

    return Ok(new BsaDiscardResultDto(
      gatewayResult.Success,
      gatewayResult.Message,
      record is null ? null : Map(record),
      gatewayResult.Submission,
      gatewayResult.RawResponse
    ));
  }

  [HttpGet("submissions")]
  public async Task<ActionResult<IEnumerable<BsaSubmissionRecordDto>>> GetSubmissions([FromQuery] string? search, [FromQuery] string? status, [FromQuery] int take = 50, CancellationToken cancellationToken = default)
  {
    var normalizedSearch = (search ?? string.Empty).Trim().ToLowerInvariant();
    var normalizedStatus = (status ?? string.Empty).Trim();
    take = take switch
    {
      <= 0 => 50,
      > 200 => 200,
      _ => take
    };

    var query = dbContext.BsaSubmissionRecords.AsQueryable();

    if (!string.IsNullOrWhiteSpace(normalizedStatus))
    {
      query = query.Where(x => x.SubmissionStatus == normalizedStatus);
    }

    if (!string.IsNullOrWhiteSpace(normalizedSearch))
    {
      query = query.Where(x =>
        x.SubmissionReference.ToLower().Contains(normalizedSearch) ||
        x.ReturnKey.ToLower().Contains(normalizedSearch) ||
        (x.BsaFileName != null && x.BsaFileName.ToLower().Contains(normalizedSearch)) ||
        (x.CreatedByUserName != null && x.CreatedByUserName.ToLower().Contains(normalizedSearch)) ||
        (x.InstitutionCode != null && x.InstitutionCode.ToLower().Contains(normalizedSearch)));
    }

    var records = await query
      .OrderByDescending(x => x.CreatedAt)
      .Take(take)
      .ToListAsync(cancellationToken);

    return Ok(records.Select(Map));
  }

  [HttpGet("submissions/{id:int}")]
  public async Task<ActionResult<BsaSubmissionRecordDto>> GetSubmission(int id, CancellationToken cancellationToken)
  {
    var record = await dbContext.BsaSubmissionRecords.FirstOrDefaultAsync(x => x.Id == id, cancellationToken);
    if (record is null)
    {
      return NotFound(new { message = "BSA submission record was not found." });
    }

    return Ok(Map(record));
  }

  private async Task<AppUser> GetCurrentUserAsync(CancellationToken cancellationToken)
  {
    var userId = Guid.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!);
    return await dbContext.Users.FirstAsync(x => x.Id == userId, cancellationToken);
  }

  private async Task LogAuditAsync(string action, string entityName, string entityId, object details, CancellationToken cancellationToken)
  {
    var userId = Guid.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!);
    await auditService.LogAsync(
      userId,
      null,
      action,
      entityName,
      entityId,
      details,
      HttpContext.Connection.RemoteIpAddress?.ToString(),
      cancellationToken
    );
  }

  private string ValidateSubmissionRequest(SubmitBsaReturnRequestDto request)
  {
    if (string.IsNullOrWhiteSpace(request.ReturnKey))
    {
      return "ReturnKey is required.";
    }

    if (request.FinancialYear <= 2007)
    {
      return "FinancialYear must be greater than 2007.";
    }

    if (request.StartDate == default || request.EndDate == default)
    {
      return "StartDate and EndDate are required.";
    }

    if (request.StartDate > request.EndDate)
    {
      return "StartDate cannot be greater than EndDate.";
    }

    if (request.StartDate.UtcDateTime.Date > DateTime.UtcNow.Date || request.EndDate.UtcDateTime.Date > DateTime.UtcNow.Date)
    {
      return "StartDate and EndDate cannot be in the future.";
    }

    if (request.ReturnItemsList is null || request.ReturnItemsList.Count == 0)
    {
      return "At least one return item is required.";
    }

    if (request.ReturnItemsList.Any(x => string.IsNullOrWhiteSpace(x.Code) || string.IsNullOrWhiteSpace(x.Value)))
    {
      return "Each return item must include both code and value.";
    }

    return string.Empty;
  }

  private BsaReturnSubmissionPayloadDto MapSubmissionPayload(SubmitBsaReturnRequestDto request)
  {
    return new BsaReturnSubmissionPayloadDto
    {
      ReturnKey = request.ReturnKey.Trim(),
      InstCode = ResolveInstitutionCode(request.InstitutionCode),
      FinYear = request.FinancialYear,
      StartDate = request.StartDate,
      EndDate = request.EndDate,
      ReturnItemsList = request.ReturnItemsList
        .Select(x => new BsaReturnItemDto
        {
          Code = x.Code.Trim(),
          Value = x.Value.Trim()
        })
        .ToList(),
      DynamicItemsList = request.DynamicItemsList?
        .Select(x => new BsaDynamicItemDto
        {
          Area = x.Area,
          DynamicItems = x.DynamicItems?
            .Select(item => new BsaReturnItemDto
            {
              Code = item.Code.Trim(),
              Value = item.Value.Trim()
            })
            .ToList()
        })
        .ToList()
    };
  }

  private string ResolveInstitutionCode(string? requestInstitutionCode)
  {
    return string.IsNullOrWhiteSpace(requestInstitutionCode)
      ? _bsaOptions.InstitutionCode.Trim()
      : requestInstitutionCode.Trim();
  }

  private static string BuildSubmissionReference()
  {
    return $"BSA{DateTime.UtcNow:yyMMddHHmmss}{Random.Shared.Next(0, 10_000):D4}";
  }

  private static string ResolveSubmissionStatus(BsaGatewaySubmissionResult result, BsaReturnSubmissionPayloadDto? response)
  {
    if (!result.Success)
    {
      if (result.Message.Contains("auth", StringComparison.OrdinalIgnoreCase))
      {
        return BsaSubmissionStatuses.AuthenticationFailed;
      }

      return result.HttpStatusCode == 422
        ? BsaSubmissionStatuses.ValidationFailed
        : BsaSubmissionStatuses.ProcessingFailed;
    }

    if (IsCompletedStatus(response?.Status))
    {
      return BsaSubmissionStatuses.ProcessedSuccessfully;
    }

    return string.IsNullOrWhiteSpace(response?.FileName)
      ? BsaSubmissionStatuses.Processing
      : BsaSubmissionStatuses.Submitted;
  }

  private static string ResolveSubmissionStatusFromStatus(BsaGatewayStatusResult result)
  {
    if (!result.Success || result.Status is null)
    {
      return BsaSubmissionStatuses.ProcessingFailed;
    }

    var processingStatus = ResolveProcessingStatus(result.Status);
    if (processingStatus.Contains("success", StringComparison.OrdinalIgnoreCase) ||
        processingStatus.Contains("processed", StringComparison.OrdinalIgnoreCase) ||
        processingStatus.Contains("complete", StringComparison.OrdinalIgnoreCase))
    {
      return BsaSubmissionStatuses.ProcessedSuccessfully;
    }

    if (processingStatus.Contains("fail", StringComparison.OrdinalIgnoreCase) ||
        processingStatus.Contains("error", StringComparison.OrdinalIgnoreCase) ||
        processingStatus.Contains("reject", StringComparison.OrdinalIgnoreCase))
    {
      return BsaSubmissionStatuses.ProcessingFailed;
    }

    if (processingStatus.Contains("discard", StringComparison.OrdinalIgnoreCase))
    {
      return BsaSubmissionStatuses.Discarded;
    }

    return BsaSubmissionStatuses.Processing;
  }

  private static string ResolveProcessingStatus(BsaStatusResponseDto? response)
  {
    if (response is null)
    {
      return string.Empty;
    }

    var processingStatus = response.ProcessingResults?
      .Select(x => x.Status)
      .FirstOrDefault(x => !string.IsNullOrWhiteSpace(x));

    return FirstNonEmpty(processingStatus, response.Status, response.Notification);
  }

  private static bool IsCompletedStatus(string? status)
  {
    if (string.IsNullOrWhiteSpace(status))
    {
      return false;
    }

    return status.Contains("success", StringComparison.OrdinalIgnoreCase) ||
           status.Contains("processed", StringComparison.OrdinalIgnoreCase) ||
           status.Contains("complete", StringComparison.OrdinalIgnoreCase);
  }

  private static string FirstNonEmpty(params string?[] values)
  {
    return values.FirstOrDefault(value => !string.IsNullOrWhiteSpace(value)) ?? string.Empty;
  }

  private static BsaSubmissionRecordDto Map(BsaSubmissionRecord record)
  {
    return new BsaSubmissionRecordDto(
      record.Id,
      record.SubmissionReference,
      record.ReturnKey,
      record.InstitutionCode,
      record.FinancialYear,
      record.PeriodStart,
      record.PeriodEnd,
      record.BsaFileName,
      record.SubmissionStatus,
      record.Notification,
      record.LastProcessingStatus,
      record.CreatedByUserName,
      record.CreatedByBranchCode,
      record.CreatedAt,
      record.UpdatedAt,
      record.SubmittedAt,
      record.LastStatusCheckedAt,
      record.CompletedAt,
      record.ErrorMessage,
      record.RequestPayload,
      record.SubmissionResponsePayload,
      record.StatusResponsePayload,
      record.DiscardRequestPayload,
      record.DiscardResponsePayload
    );
  }
}
