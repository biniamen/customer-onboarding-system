using System.Security.Claims;
using System.Text.Json;
using CustomerOnboarding.Backend.Data;
using CustomerOnboarding.Backend.Dtos;
using CustomerOnboarding.Backend.Models;
using CustomerOnboarding.Backend.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace CustomerOnboarding.Backend.Controllers;

[ApiController]
[Route("api/core/telebirr-transfers")]
[Authorize]
public class TelebirrTransfersController(
  AppDbContext dbContext,
  ITelebirrTransferService telebirrTransferService,
  IAuditService auditService
) : ControllerBase
{
  [HttpPost("account-lookup")]
  public async Task<ActionResult<TelebirrAccountLookupDto>> LookupCustomerAccount([FromBody] TelebirrAccountLookupRequest request, CancellationToken cancellationToken)
  {
    var branchCode = await GetCurrentBranchCodeAsync(cancellationToken);
    var accountResult = await telebirrTransferService.QueryCustomerAccountAsync(branchCode, request.AccountNumber.Trim(), cancellationToken);
    var reasons = new List<string>();
    var requiredCurrency = telebirrTransferService.RequiredTransferCurrency;
    var accountCurrency = (accountResult.Currency ?? string.Empty).Trim().ToUpperInvariant();

    if (!accountResult.Success)
    {
      reasons.Add(accountResult.Message);
    }
    if (accountResult.NoDebitStatus.Equals("Y", StringComparison.OrdinalIgnoreCase))
    {
      reasons.Add("Account is blocked for debit transactions.");
    }
    if (accountResult.FrozenStatus.Equals("Y", StringComparison.OrdinalIgnoreCase))
    {
      reasons.Add("Account is frozen.");
    }
    if (!string.IsNullOrWhiteSpace(accountCurrency) && !string.Equals(accountCurrency, requiredCurrency, StringComparison.OrdinalIgnoreCase))
    {
      reasons.Add($"Only {requiredCurrency} accounts are allowed.");
    }

    var canProceed = reasons.Count == 0;
    var message = canProceed
      ? "Customer account verified successfully."
      : string.Join(" ", reasons.Where(x => !string.IsNullOrWhiteSpace(x)));

    return Ok(new TelebirrAccountLookupDto(
      accountResult.AccountNumber,
      accountResult.AccountBranchCode,
      accountResult.CustomerNumber,
      accountResult.CustomerName,
      accountResult.AccountClass,
      accountResult.Currency ?? "ETB",
      accountResult.AvailableBalance,
      accountResult.NoDebitStatus,
      accountResult.NoCreditStatus,
      accountResult.FrozenStatus,
      accountResult.ResponseStatus,
      canProceed,
      telebirrTransferService.MinimumRemainingBalance,
      message,
      accountResult.RawResponse
    ));
  }

  [HttpPost("agent-lookup")]
  public async Task<ActionResult<TelebirrAgentLookupDto>> LookupTelebirrAgent([FromBody] TelebirrAgentLookupRequest request, CancellationToken cancellationToken)
  {
    var agentResult = await telebirrTransferService.QueryAgentAsync(request.TelebirrShortCode.Trim(), cancellationToken);
    return Ok(new TelebirrAgentLookupDto(
      agentResult.ShortCode,
      agentResult.OrganizationName,
      agentResult.ResultType,
      agentResult.ResultCode,
      agentResult.ResultDesc,
      agentResult.ConversationId,
      agentResult.Success,
      agentResult.Message,
      agentResult.RawResponse
    ));
  }

  [HttpPost("submit")]
  [Authorize(Roles = UserRoles.Maker)]
  public async Task<ActionResult<TelebirrTransferRecordDto>> Submit([FromBody] SubmitTelebirrTransferRequest request, CancellationToken cancellationToken)
  {
    var currentUser = await GetCurrentUserAsync(cancellationToken);
    var accountResult = await telebirrTransferService.QueryCustomerAccountAsync(currentUser.BranchCode, request.AccountNumber.Trim(), cancellationToken);
    var validationMessage = telebirrTransferService.ValidateTransferRules(accountResult, request.Amount);
    if (!string.IsNullOrWhiteSpace(validationMessage))
    {
      return BadRequest(new { message = validationMessage });
    }

    var agentResult = await telebirrTransferService.QueryAgentAsync(request.TelebirrShortCode.Trim(), cancellationToken);
    if (!agentResult.Success)
    {
      return BadRequest(new { message = agentResult.Message });
    }

    var narration = string.IsNullOrWhiteSpace(request.Narration) ? "Telebirr agent transfer" : request.Narration.Trim();
    var record = new TelebirrTransferRequest
    {
      AccountNumber = request.AccountNumber.Trim(),
      AccountBranchCode = accountResult.AccountBranchCode,
      CustomerName = accountResult.CustomerName,
      TelebirrShortCode = request.TelebirrShortCode.Trim(),
      TelebirrOrganizationName = agentResult.OrganizationName,
      Amount = request.Amount,
      Currency = string.IsNullOrWhiteSpace(accountResult.Currency) ? "ETB" : accountResult.Currency,
      Narration = narration,
      Status = TelebirrTransferStatuses.Pending,
      MakerBranchId = int.TryParse(currentUser.BranchCode, out var branchId) ? branchId : null,
      MakerUserName = currentUser.Username,
      RequestPayload = JsonSerializer.Serialize(new
      {
        AccountBranchCode = accountResult.AccountBranchCode,
        AccountNumber = request.AccountNumber.Trim(),
        CustomerNumber = accountResult.CustomerNumber,
        CustomerName = accountResult.CustomerName,
        TelebirrShortCode = request.TelebirrShortCode.Trim(),
        TelebirrOrganizationName = agentResult.OrganizationName,
        request.Amount,
        Narration = narration
      }),
      ResponsePayload = JsonSerializer.Serialize(new
      {
        AccountLookup = accountResult.RawResponse,
        AgentLookup = agentResult.RawResponse
      })
    };

    dbContext.TelebirrTransferRequests.Add(record);
    await dbContext.SaveChangesAsync(cancellationToken);

    await auditService.LogAsync(
      Guid.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!),
      null,
      "SUBMIT_TELEBIRR_TRANSFER",
      "TelebirrTransferRequest",
      record.Id.ToString(),
      new { record.AccountNumber, record.TelebirrShortCode, record.Amount, record.MakerBranchId },
      HttpContext.Connection.RemoteIpAddress?.ToString(),
      cancellationToken
    );

    return CreatedAtAction(nameof(Get), new { id = record.Id }, Map(record));
  }

  [HttpGet("mine")]
  [Authorize(Roles = UserRoles.Maker)]
  public async Task<ActionResult<IEnumerable<TelebirrTransferRecordDto>>> Mine(CancellationToken cancellationToken)
  {
    var currentUser = await GetCurrentUserAsync(cancellationToken);
    var records = await dbContext.TelebirrTransferRequests
      .Where(x => x.MakerUserName == currentUser.Username)
      .OrderByDescending(x => x.CreatedAt)
      .ToListAsync(cancellationToken);

    return Ok(records.Select(Map));
  }

  [HttpGet("pending")]
  [Authorize(Roles = UserRoles.Checker)]
  public async Task<ActionResult<IEnumerable<TelebirrTransferRecordDto>>> Pending(CancellationToken cancellationToken)
  {
    var currentUser = await GetCurrentUserAsync(cancellationToken);
    var branchId = int.TryParse(currentUser.BranchCode, out var parsedBranchId) ? parsedBranchId : (int?)null;

    var records = await dbContext.TelebirrTransferRequests
      .Where(x => x.Status == TelebirrTransferStatuses.Pending && x.MakerBranchId == branchId)
      .OrderByDescending(x => x.CreatedAt)
      .ToListAsync(cancellationToken);

    return Ok(records.Select(Map));
  }

  [HttpGet("completed")]
  [Authorize(Roles = $"{UserRoles.Admin},{UserRoles.Maker},{UserRoles.Checker},{UserRoles.ReportViewer}")]
  public async Task<ActionResult<IEnumerable<TelebirrTransferRecordDto>>> Completed(CancellationToken cancellationToken)
  {
    var currentUser = await GetCurrentUserAsync(cancellationToken);
    var branchId = int.TryParse(currentUser.BranchCode, out var parsedBranchId) ? parsedBranchId : (int?)null;
    var hasGlobalReportAccess =
      string.Equals(currentUser.Role, UserRoles.ReportViewer, StringComparison.OrdinalIgnoreCase) ||
      string.Equals(currentUser.Role, UserRoles.Admin, StringComparison.OrdinalIgnoreCase);

    var query = dbContext.TelebirrTransferRequests
      .AsQueryable()
      .Where(x => x.Status != TelebirrTransferStatuses.Pending);

    if (!hasGlobalReportAccess)
    {
      query = query.Where(x => x.MakerBranchId == branchId);
    }

    var records = await query
      .OrderByDescending(x => x.ApprovedAt ?? x.RejectedAt ?? x.CreatedAt)
      .ToListAsync(cancellationToken);

    return Ok(records.Select(Map));
  }

  [HttpGet("report")]
  [Authorize(Roles = $"{UserRoles.Admin},{UserRoles.Maker},{UserRoles.Checker},{UserRoles.ReportViewer}")]
  public async Task<ActionResult<TelebirrTransferReportResponseDto>> Report(
    [FromQuery] TelebirrTransferReportQueryDto queryDto,
    CancellationToken cancellationToken)
  {
    var currentUser = await GetCurrentUserAsync(cancellationToken);
    var branchId = int.TryParse(currentUser.BranchCode, out var parsedBranchId) ? parsedBranchId : (int?)null;
    var hasGlobalReportAccess =
      string.Equals(currentUser.Role, UserRoles.ReportViewer, StringComparison.OrdinalIgnoreCase) ||
      string.Equals(currentUser.Role, UserRoles.Admin, StringComparison.OrdinalIgnoreCase);

    var query = dbContext.TelebirrTransferRequests.AsNoTracking();
    if (!hasGlobalReportAccess)
    {
      query = query.Where(x => x.MakerBranchId == branchId);
    }

    if (!string.IsNullOrWhiteSpace(queryDto.Status))
    {
      var status = queryDto.Status.Trim().ToUpperInvariant();
      query = query.Where(x => (x.Status ?? string.Empty).ToUpper() == status);
    }

    if (queryDto.FromDate.HasValue)
    {
      var from = queryDto.FromDate.Value;
      query = query.Where(x => x.CreatedAt >= from);
    }

    if (queryDto.ToDate.HasValue)
    {
      var to = queryDto.ToDate.Value;
      query = query.Where(x => x.CreatedAt <= to);
    }

    if (!string.IsNullOrWhiteSpace(queryDto.Search))
    {
      var keyword = $"%{queryDto.Search.Trim()}%";
      query = query.Where(x =>
        EF.Functions.ILike(x.AccountNumber, keyword) ||
        EF.Functions.ILike(x.CustomerName ?? string.Empty, keyword) ||
        EF.Functions.ILike(x.TelebirrShortCode, keyword) ||
        EF.Functions.ILike(x.TelebirrOrganizationName ?? string.Empty, keyword) ||
        EF.Functions.ILike(x.CbsReference ?? string.Empty, keyword) ||
        EF.Functions.ILike(x.TransactionId ?? string.Empty, keyword) ||
        EF.Functions.ILike(x.ConversationId ?? string.Empty, keyword) ||
        EF.Functions.ILike(x.OriginatorConversationId ?? string.Empty, keyword) ||
        EF.Functions.ILike(x.ResponseCode ?? string.Empty, keyword) ||
        EF.Functions.ILike(x.ResponseDesc ?? string.Empty, keyword) ||
        EF.Functions.ILike(x.ResultCode ?? string.Empty, keyword) ||
        EF.Functions.ILike(x.ResultDesc ?? string.Empty, keyword) ||
        EF.Functions.ILike(x.MakerUserName ?? string.Empty, keyword) ||
        EF.Functions.ILike(x.CheckerUserName ?? string.Empty, keyword) ||
        EF.Functions.ILike(x.AccountBranchCode ?? string.Empty, keyword) ||
        EF.Functions.ILike(x.Narration, keyword));
    }

    var sortBy = (queryDto.SortBy ?? "createdAt").Trim().ToLowerInvariant();
    var sortDirection = (queryDto.SortDirection ?? "desc").Trim().ToLowerInvariant();
    var sortAscending = sortDirection == "asc";

    query = sortBy switch
    {
      "customername" => sortAscending ? query.OrderBy(x => x.CustomerName) : query.OrderByDescending(x => x.CustomerName),
      "accountnumber" => sortAscending ? query.OrderBy(x => x.AccountNumber) : query.OrderByDescending(x => x.AccountNumber),
      "amount" => sortAscending ? query.OrderBy(x => x.Amount) : query.OrderByDescending(x => x.Amount),
      "status" => sortAscending ? query.OrderBy(x => x.Status) : query.OrderByDescending(x => x.Status),
      "cbsreference" => sortAscending ? query.OrderBy(x => x.CbsReference) : query.OrderByDescending(x => x.CbsReference),
      "transactionid" => sortAscending ? query.OrderBy(x => x.TransactionId) : query.OrderByDescending(x => x.TransactionId),
      "approvedat" => sortAscending ? query.OrderBy(x => x.ApprovedAt) : query.OrderByDescending(x => x.ApprovedAt),
      _ => sortAscending ? query.OrderBy(x => x.CreatedAt) : query.OrderByDescending(x => x.CreatedAt)
    };

    var totalRecords = await query.CountAsync(cancellationToken);
    var pageSize = queryDto.PageSize == -1 ? int.MaxValue : (queryDto.PageSize <= 0 ? 20 : queryDto.PageSize);
    var page = queryDto.Page <= 0 ? 1 : queryDto.Page;

    List<TelebirrTransferRequest> records;
    int totalPages;

    if (pageSize == int.MaxValue)
    {
      records = await query.ToListAsync(cancellationToken);
      totalPages = 1;
      page = 1;
    }
    else
    {
      totalPages = Math.Max(1, (int)Math.Ceiling(totalRecords / (double)pageSize));
      if (page > totalPages)
      {
        page = totalPages;
      }

      var skip = (page - 1) * pageSize;
      records = await query.Skip(skip).Take(pageSize).ToListAsync(cancellationToken);
    }

    return Ok(new TelebirrTransferReportResponseDto(
      page,
      pageSize,
      totalRecords,
      totalPages,
      records.Select(Map).ToList()
    ));
  }

  [HttpGet("dashboard-stats")]
  [Authorize(Roles = $"{UserRoles.Admin},{UserRoles.Maker},{UserRoles.Checker},{UserRoles.ReportViewer}")]
  public async Task<ActionResult<TelebirrDashboardStatsDto>> DashboardStats(
    [FromQuery] DateTimeOffset? fromDate,
    [FromQuery] DateTimeOffset? toDate,
    CancellationToken cancellationToken)
  {
    var currentUser = await GetCurrentUserAsync(cancellationToken);
    var hasGlobalReportAccess =
      string.Equals(currentUser.Role, UserRoles.ReportViewer, StringComparison.OrdinalIgnoreCase) ||
      string.Equals(currentUser.Role, UserRoles.Admin, StringComparison.OrdinalIgnoreCase);
    var currentBranchId = int.TryParse(currentUser.BranchCode, out var parsedBranchId) ? parsedBranchId : (int?)null;

    var scopedQuery = dbContext.TelebirrTransferRequests
      .AsNoTracking()
      .Select(x => new DashboardRow(
        x.Status ?? string.Empty,
        x.TelebirrShortCode ?? string.Empty,
        x.CreatedAt,
        x.MakerBranchId,
        x.Amount
      ));

    if (!hasGlobalReportAccess)
    {
      scopedQuery = scopedQuery.Where(x => x.MakerBranchId == currentBranchId);
    }

    var rows = await scopedQuery.ToListAsync(cancellationToken);
    var branchLookup = await dbContext.Branches
      .AsNoTracking()
      .ToDictionaryAsync(x => x.BranchCode, x => x.BranchName, cancellationToken);

    var (rangeStartUtc, rangeEndUtc) = ResolveDashboardRangeUtc(fromDate, toDate);
    var rangeRows = rows
      .Where(x => x.CreatedAt >= rangeStartUtc && x.CreatedAt < rangeEndUtc)
      .ToList();

    var todayStats = BuildStatusBreakdown(rangeRows);
    var grandStats = BuildStatusBreakdown(rows);
    var branchStats = BuildBranchStats(
      rows,
      rangeStartUtc,
      rangeEndUtc,
      branchLookup,
      hasGlobalReportAccess,
      currentUser.BranchCode
    );

    TelebirrDashboardUserStatsDto? userStats = null;
    if (string.Equals(currentUser.Role, UserRoles.Admin, StringComparison.OrdinalIgnoreCase))
    {
      var totalUsers = await dbContext.Users.CountAsync(cancellationToken);
      var activeUsers = await dbContext.Users.CountAsync(x => x.IsActive, cancellationToken);
      userStats = new TelebirrDashboardUserStatsDto(
        totalUsers,
        activeUsers,
        Math.Max(0, totalUsers - activeUsers)
      );
    }

    return Ok(new TelebirrDashboardStatsDto(
      hasGlobalReportAccess ? "ALL_BRANCHES" : "BRANCH_ONLY",
      hasGlobalReportAccess ? null : currentUser.BranchCode,
      rangeStartUtc,
      rangeEndUtc,
      todayStats,
      grandStats,
      branchStats,
      userStats
    ));
  }

  [HttpGet("{id:int}")]
  public async Task<ActionResult<TelebirrTransferRecordDto>> Get(int id, CancellationToken cancellationToken)
  {
    var currentUser = await GetCurrentUserAsync(cancellationToken);
    var record = await dbContext.TelebirrTransferRequests.FirstOrDefaultAsync(x => x.Id == id, cancellationToken);
    if (record is null)
    {
      return NotFound(new { message = "Transfer request not found." });
    }

    if (!CanAccessRecord(currentUser, record))
    {
      return Forbid();
    }

    return Ok(Map(record));
  }

  [HttpPost("{id:int}/approve")]
  [Authorize(Roles = UserRoles.Checker)]
  public async Task<ActionResult<TelebirrTransferRecordDto>> Approve(int id, [FromBody] ApproveTelebirrTransferRequest request, CancellationToken cancellationToken)
  {
    var currentUser = await GetCurrentUserAsync(cancellationToken);
    var record = await dbContext.TelebirrTransferRequests.FirstOrDefaultAsync(x => x.Id == id, cancellationToken);
    if (record is null)
    {
      return NotFound(new { message = "Transfer request not found." });
    }

    if (record.Status != TelebirrTransferStatuses.Pending)
    {
      return BadRequest(new { message = "Only pending transfer requests can be approved." });
    }

    if (!CanAccessRecord(currentUser, record))
    {
      return Forbid();
    }

    var checkerComment = request.CheckerComment?.Trim() ?? string.Empty;
    var processingResult = await telebirrTransferService.ProcessApprovedTransferAsync(
      currentUser.BranchCode,
      record.AccountBranchCode ?? string.Empty,
      currentUser.Username,
      checkerComment,
      record.Id,
      record.AccountNumber,
      record.TelebirrShortCode,
      record.Amount,
      record.Narration,
      cancellationToken
    );

    record.CheckerUserName = currentUser.Username;
    record.Status = processingResult.Success ? TelebirrTransferStatuses.Approved : TelebirrTransferStatuses.Failed;
    record.ApprovedAt = processingResult.Success ? DateTimeOffset.UtcNow : null;
    record.CbsReference = processingResult.CbsReference;
    record.CbsMessageStatus = processingResult.CbsMessageStatus;
    record.CbsResponseDesc = processingResult.CbsResponseDesc;
    record.ReversalReference = processingResult.ReversalReference;
    record.ReversalStatus = processingResult.ReversalStatus;
    record.ReversalResponseDesc = processingResult.ReversalResponseDesc;
    record.ResponseCode = processingResult.ResponseCode;
    record.ResponseDesc = processingResult.ResponseDesc ?? processingResult.Message;
    record.ServiceStatus = processingResult.ServiceStatus;
    record.ResultType = processingResult.ResultType;
    record.ResultCode = processingResult.ResultCode;
    record.ResultDesc = processingResult.ResultDesc;
    record.TransactionId = processingResult.TransactionId;
    record.ConversationId = processingResult.ConversationId;
    record.OriginatorConversationId = processingResult.OriginatorConversationId;
    record.RequestPayload = processingResult.RequestPayload;
    record.ResponsePayload = processingResult.ResponsePayload;

    await dbContext.SaveChangesAsync(cancellationToken);

    await auditService.LogAsync(
      Guid.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!),
      null,
      "APPROVE_TELEBIRR_TRANSFER",
      "TelebirrTransferRequest",
      record.Id.ToString(),
      new { record.Status, processingResult.Message, record.TransactionId },
      HttpContext.Connection.RemoteIpAddress?.ToString(),
      cancellationToken
    );

    return Ok(Map(record));
  }

  [HttpPost("{id:int}/reject")]
  [Authorize(Roles = UserRoles.Checker)]
  public async Task<ActionResult<TelebirrTransferRecordDto>> Reject(int id, [FromBody] RejectTelebirrTransferRequest request, CancellationToken cancellationToken)
  {
    var currentUser = await GetCurrentUserAsync(cancellationToken);
    var record = await dbContext.TelebirrTransferRequests.FirstOrDefaultAsync(x => x.Id == id, cancellationToken);
    if (record is null)
    {
      return NotFound(new { message = "Transfer request not found." });
    }

    if (record.Status != TelebirrTransferStatuses.Pending)
    {
      return BadRequest(new { message = "Only pending transfer requests can be rejected." });
    }

    if (!CanAccessRecord(currentUser, record))
    {
      return Forbid();
    }

    var rejectionReason = (request.RejectionReason ?? string.Empty).Trim();
    if (string.IsNullOrWhiteSpace(rejectionReason))
    {
      return BadRequest(new { message = "Please provide a short reason before rejecting the request." });
    }

    record.Status = TelebirrTransferStatuses.Rejected;
    record.CheckerUserName = currentUser.Username;
    record.RejectedAt = DateTimeOffset.UtcNow;
    record.RejectionReason = rejectionReason;
    record.ResponseCode = "REJECTED";
    record.ResponseDesc = record.RejectionReason;
    record.ServiceStatus = "REJECTED";

    await dbContext.SaveChangesAsync(cancellationToken);

    await auditService.LogAsync(
      Guid.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!),
      null,
      "REJECT_TELEBIRR_TRANSFER",
      "TelebirrTransferRequest",
      record.Id.ToString(),
      new { record.RejectionReason },
      HttpContext.Connection.RemoteIpAddress?.ToString(),
      cancellationToken
    );

    return Ok(Map(record));
  }

  private async Task<AppUser> GetCurrentUserAsync(CancellationToken cancellationToken)
  {
    var userId = Guid.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!);
    return await dbContext.Users.FirstAsync(x => x.Id == userId, cancellationToken);
  }

  private async Task<string> GetCurrentBranchCodeAsync(CancellationToken cancellationToken)
  {
    return (await GetCurrentUserAsync(cancellationToken)).BranchCode;
  }

  private static bool CanAccessRecord(AppUser user, TelebirrTransferRequest record)
  {
    if (user.Role == UserRoles.ReportViewer || user.Role == UserRoles.Admin)
    {
      return true;
    }

    if (user.Role == UserRoles.Maker)
    {
      return string.Equals(record.MakerUserName, user.Username, StringComparison.OrdinalIgnoreCase);
    }

    var checkerBranchId = int.TryParse(user.BranchCode, out var parsedBranchId) ? parsedBranchId : (int?)null;
    return record.MakerBranchId == checkerBranchId;
  }

  private static TelebirrTransferRecordDto Map(TelebirrTransferRequest record)
  {
    return new TelebirrTransferRecordDto(
      record.Id,
      record.AccountNumber,
      record.AccountBranchCode,
      record.CustomerName,
      record.TelebirrShortCode,
      record.TelebirrOrganizationName,
      record.Amount,
      record.Currency,
      record.Narration,
      record.Status,
      record.MakerBranchId,
      record.MakerUserName,
      record.CheckerUserName,
      record.CreatedAt,
      record.ApprovedAt,
      record.RejectedAt,
      record.RejectionReason,
      record.TransactionId,
      record.ConversationId,
      record.OriginatorConversationId,
      record.CbsReference,
      record.CbsMessageStatus,
      record.CbsResponseDesc,
      record.ReversalReference,
      record.ReversalStatus,
      record.ReversalResponseDesc,
      record.ResponseCode,
      record.ResponseDesc,
      record.ServiceStatus,
      record.ResultType,
      record.ResultCode,
      record.ResultDesc
    );
  }

  private static TelebirrStatusBreakdownDto BuildStatusBreakdown(IEnumerable<DashboardRow> rows)
  {
    var data = rows.ToList();
    return new TelebirrStatusBreakdownDto(
      data.Count,
      data.Count(x => string.Equals(x.Status, TelebirrTransferStatuses.Approved, StringComparison.OrdinalIgnoreCase)),
      data.Count(x => string.Equals(x.Status, TelebirrTransferStatuses.Failed, StringComparison.OrdinalIgnoreCase)),
      data.Count(x => string.Equals(x.Status, TelebirrTransferStatuses.Rejected, StringComparison.OrdinalIgnoreCase)),
      data.Count(x => string.Equals(x.Status, TelebirrTransferStatuses.Pending, StringComparison.OrdinalIgnoreCase)),
      data
        .Where(x => !string.IsNullOrWhiteSpace(x.TelebirrShortCode))
        .Select(x => x.TelebirrShortCode.Trim())
        .Distinct(StringComparer.OrdinalIgnoreCase)
        .Count(),
      data
        .Where(x => string.Equals(x.Status, TelebirrTransferStatuses.Approved, StringComparison.OrdinalIgnoreCase))
        .Sum(x => x.Amount)
    );
  }

  private static IReadOnlyList<TelebirrBranchStatsDto> BuildBranchStats(
    IReadOnlyCollection<DashboardRow> rows,
    DateTimeOffset todayStartUtc,
    DateTimeOffset todayEndUtc,
    IReadOnlyDictionary<string, string> branchLookup,
    bool hasGlobalReportAccess,
    string currentBranchCode
  )
  {
    var grouped = rows
      .GroupBy(x => ResolveBranchCode(x.MakerBranchId))
      .Select(group =>
      {
        var branchRows = group.ToList();
        var todayRows = branchRows.Where(x => x.CreatedAt >= todayStartUtc && x.CreatedAt < todayEndUtc);
        var branchCode = group.Key;
        return new TelebirrBranchStatsDto(
          branchCode,
          ResolveBranchName(branchCode, branchLookup),
          BuildStatusBreakdown(todayRows),
          BuildStatusBreakdown(branchRows)
        );
      })
      .OrderByDescending(x => x.GrandTotal.TotalTransferredAmount)
      .ThenBy(x => x.BranchCode)
      .ToList();

    if (hasGlobalReportAccess)
    {
      return grouped;
    }

    var match = grouped.FirstOrDefault(x => string.Equals(x.BranchCode, currentBranchCode, StringComparison.OrdinalIgnoreCase));
    if (match is not null)
    {
      return [match];
    }

    return
    [
      new TelebirrBranchStatsDto(
        currentBranchCode,
        ResolveBranchName(currentBranchCode, branchLookup),
        new TelebirrStatusBreakdownDto(0, 0, 0, 0, 0, 0, 0),
        new TelebirrStatusBreakdownDto(0, 0, 0, 0, 0, 0, 0)
      )
    ];
  }

  private static string ResolveBranchCode(int? branchId)
  {
    if (!branchId.HasValue)
    {
      return "N/A";
    }

    return branchId.Value.ToString("000");
  }

  private static string ResolveBranchName(string branchCode, IReadOnlyDictionary<string, string> branchLookup)
  {
    if (branchLookup.TryGetValue(branchCode, out var branchName) && !string.IsNullOrWhiteSpace(branchName))
    {
      return branchName;
    }

    return branchCode == "N/A" ? "Unassigned branch" : "Branch";
  }

  private static (DateTimeOffset StartUtc, DateTimeOffset EndUtc) ResolveDashboardRangeUtc(DateTimeOffset? fromDate, DateTimeOffset? toDate)
  {
    var timeZone = ResolveEastAfricaTimeZone();
    var fallback = TimeZoneInfo.ConvertTime(DateTimeOffset.UtcNow, timeZone);

    var rangeStartLocal = fromDate.HasValue
      ? TimeZoneInfo.ConvertTime(fromDate.Value, timeZone)
      : new DateTimeOffset(fallback.Year, fallback.Month, fallback.Day, 0, 0, 0, fallback.Offset);

    var rangeEndLocal = toDate.HasValue
      ? TimeZoneInfo.ConvertTime(toDate.Value, timeZone)
      : rangeStartLocal;

    var normalizedStart = new DateTimeOffset(rangeStartLocal.Year, rangeStartLocal.Month, rangeStartLocal.Day, 0, 0, 0, rangeStartLocal.Offset);
    var normalizedEnd = new DateTimeOffset(rangeEndLocal.Year, rangeEndLocal.Month, rangeEndLocal.Day, 0, 0, 0, rangeEndLocal.Offset).AddDays(1);

    if (normalizedEnd <= normalizedStart)
    {
      normalizedEnd = normalizedStart.AddDays(1);
    }

    return (normalizedStart.ToUniversalTime(), normalizedEnd.ToUniversalTime());
  }

  private static TimeZoneInfo ResolveEastAfricaTimeZone()
  {
    try
    {
      return TimeZoneInfo.FindSystemTimeZoneById("E. Africa Standard Time");
    }
    catch
    {
      try
      {
        return TimeZoneInfo.FindSystemTimeZoneById("Africa/Nairobi");
      }
      catch
      {
        return TimeZoneInfo.Utc;
      }
    }
  }

  private sealed record DashboardRow(
    string Status,
    string TelebirrShortCode,
    DateTimeOffset CreatedAt,
    int? MakerBranchId,
    decimal Amount
  );
}
