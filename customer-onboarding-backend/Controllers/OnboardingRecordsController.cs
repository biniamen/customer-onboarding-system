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
[Route("api/core/onboarding-records")]
[Authorize]
public class OnboardingRecordsController(
  AppDbContext dbContext,
  IAuditService auditService,
  IAccountApprovalService accountApprovalService,
  IFundingSourceLookupService fundingSourceLookupService,
  IAccountClassLookupService accountClassLookupService
) : ControllerBase
{
  private static readonly JsonSerializerOptions PersistJsonOptions = new()
  {
    PropertyNamingPolicy = JsonNamingPolicy.CamelCase
  };

  [HttpGet("mine")]
  [Authorize(Roles = UserRoles.Maker)]
  public async Task<ActionResult<IEnumerable<OnboardingRecordDto>>> Mine(CancellationToken cancellationToken)
  {
    var userId = GetRequiredUserId();
    var records = await dbContext.OnboardingRecords
      .Include(x => x.MakerUser)
      .Include(x => x.CheckerUser)
      .Include(x => x.KycReviewerUser)
      .Where(x => x.MakerUserId == userId)
      .OrderByDescending(x => x.CreatedAtUtc)
      .ToListAsync(cancellationToken);

    return Ok(records.Select(Map));
  }

  [HttpGet("customers/{customerNumber}/eligible-funding-accounts")]
  [Authorize(Roles = UserRoles.Maker)]
  public async Task<ActionResult<IEnumerable<EligibleFundingAccountDto>>> EligibleFundingAccounts(string customerNumber, CancellationToken cancellationToken)
  {
    if (string.IsNullOrWhiteSpace(customerNumber))
    {
      return BadRequest(new { message = "Customer number is required." });
    }

    var accounts = await fundingSourceLookupService.GetEligibleAccountsAsync(customerNumber, cancellationToken);
    return Ok(accounts);
  }

  [HttpGet("account-classes")]
  [Authorize(Roles = UserRoles.Maker)]
  public async Task<ActionResult<IEnumerable<AccountClassOptionDto>>> AccountClasses(CancellationToken cancellationToken)
  {
    var accountClasses = await accountClassLookupService.GetAccountClassesAsync(cancellationToken);
    return Ok(accountClasses);
  }

  [HttpGet("pending")]
  [Authorize(Roles = UserRoles.Checker)]
  public async Task<ActionResult<IEnumerable<OnboardingRecordDto>>> Pending(CancellationToken cancellationToken)
  {
    var userId = GetRequiredUserId();
    var checker = await dbContext.Users.FirstAsync(x => x.Id == userId, cancellationToken);
    var records = await dbContext.OnboardingRecords
      .Include(x => x.MakerUser)
      .Include(x => x.CheckerUser)
      .Include(x => x.KycReviewerUser)
      .Where(x => x.Status == WorkflowStatuses.PendingCheckerApproval && x.BranchCode == checker.BranchCode)
      .OrderByDescending(x => x.CreatedAtUtc)
      .ToListAsync(cancellationToken);

    return Ok(records.Select(Map));
  }

  [HttpGet("completed")]
  public async Task<ActionResult<IEnumerable<OnboardingRecordDto>>> Completed(CancellationToken cancellationToken)
  {
    var userId = GetRequiredUserId();
    var currentUser = await dbContext.Users.FirstAsync(x => x.Id == userId, cancellationToken);
    var records = await dbContext.OnboardingRecords
      .Include(x => x.MakerUser)
      .Include(x => x.CheckerUser)
      .Include(x => x.KycReviewerUser)
      .Where(x =>
        x.BranchCode == currentUser.BranchCode &&
        (x.Status == WorkflowStatuses.AccountCreated || x.Status == WorkflowStatuses.KycReviewed))
      .OrderByDescending(x => x.KycReviewedAtUtc ?? x.ReviewedAtUtc ?? x.UpdatedAtUtc)
      .ToListAsync(cancellationToken);

    return Ok(records.Select(Map));
  }

  [HttpGet("report")]
  [Authorize(Roles = UserRoles.Admin + "," + UserRoles.ReportViewer + "," + UserRoles.KycUnit)]
  public async Task<ActionResult<OnboardingReportResponseDto>> Report(
    [FromQuery] string? search,
    [FromQuery] string? status,
    [FromQuery] DateTime? fromDate,
    [FromQuery] DateTime? toDate,
    [FromQuery] int page = 1,
    [FromQuery] int pageSize = 10,
    [FromQuery] string? sortBy = "submittedAtUtc",
    [FromQuery] string? sortDirection = "desc",
    CancellationToken cancellationToken = default)
  {
    var currentUser = await dbContext.Users.AsNoTracking().FirstAsync(x => x.Id == GetRequiredUserId(), cancellationToken);
    var role = User.FindFirstValue(ClaimTypes.Role) ?? string.Empty;
    var baseQuery = ApplyReportScope(
      dbContext.OnboardingRecords
        .AsNoTracking()
        .Include(x => x.MakerUser)
        .Include(x => x.CheckerUser)
        .Include(x => x.KycReviewerUser),
      currentUser,
      role);

    if (!string.IsNullOrWhiteSpace(search))
    {
      var keyword = search.Trim().ToLowerInvariant();
      baseQuery = baseQuery.Where(x =>
        x.CaseReference.ToLower().Contains(keyword) ||
        x.CustomerName.ToLower().Contains(keyword) ||
        x.CustomerNumber.ToLower().Contains(keyword) ||
        x.BranchCode.ToLower().Contains(keyword) ||
        x.AccountClass.ToLower().Contains(keyword) ||
        x.AccountClassName.ToLower().Contains(keyword) ||
        x.Status.ToLower().Contains(keyword) ||
        (x.AccountNumber != null && x.AccountNumber.ToLower().Contains(keyword)) ||
        (x.Email != null && x.Email.ToLower().Contains(keyword)) ||
        (x.MobileNumber != null && x.MobileNumber.ToLower().Contains(keyword)));
    }

    if (!string.IsNullOrWhiteSpace(status))
    {
      var normalizedStatus = status.Trim().ToUpperInvariant();
      baseQuery = baseQuery.Where(x => x.Status == normalizedStatus);
    }

    if (fromDate.HasValue)
    {
      var start = EnsureUtc(fromDate.Value);
      baseQuery = baseQuery.Where(x => x.SubmittedAtUtc >= start);
    }

    if (toDate.HasValue)
    {
      var end = EnsureUtc(toDate.Value);
      baseQuery = baseQuery.Where(x => x.SubmittedAtUtc <= end);
    }

    baseQuery = ApplySorting(baseQuery, sortBy, sortDirection);

    var safePage = Math.Max(1, page);
    var safePageSize = pageSize == -1 ? -1 : Math.Max(1, pageSize);
    var totalRecords = await baseQuery.CountAsync(cancellationToken);
    var totalPages = safePageSize == -1 ? 1 : Math.Max(1, (int)Math.Ceiling(totalRecords / (double)safePageSize));

    var items = safePageSize == -1
      ? await baseQuery.ToListAsync(cancellationToken)
      : await baseQuery.Skip((safePage - 1) * safePageSize).Take(safePageSize).ToListAsync(cancellationToken);

    return Ok(new OnboardingReportResponseDto(safePage, safePageSize, totalRecords, totalPages, items.Select(Map).ToList()));
  }

  [HttpGet("dashboard-stats")]
  [Authorize(Roles = UserRoles.Admin + "," + UserRoles.ReportViewer + "," + UserRoles.KycUnit)]
  public async Task<ActionResult<OnboardingDashboardStatsDto>> DashboardStats(
    [FromQuery] DateTime? fromDate,
    [FromQuery] DateTime? toDate,
    CancellationToken cancellationToken)
  {
    var currentUser = await dbContext.Users.AsNoTracking().FirstAsync(x => x.Id == GetRequiredUserId(), cancellationToken);
    var role = User.FindFirstValue(ClaimTypes.Role) ?? string.Empty;
    var baseQuery = ApplyReportScope(dbContext.OnboardingRecords.AsNoTracking(), currentUser, role);

    var rangeStartUtc = EnsureUtc(fromDate ?? DateTime.UtcNow.Date);
    var rangeEndUtc = EnsureUtc(toDate ?? DateTime.UtcNow.Date.AddDays(1).AddTicks(-1));

    var rangeQuery = baseQuery.Where(x => x.SubmittedAtUtc >= rangeStartUtc && x.SubmittedAtUtc <= rangeEndUtc);
    var branchNames = await dbContext.Branches.AsNoTracking().ToDictionaryAsync(x => x.BranchCode, x => x.BranchName, cancellationToken);

    var branchGroups = await baseQuery
      .GroupBy(x => x.BranchCode)
      .Select(group => new
      {
        BranchCode = group.Key,
        Today = new
        {
          Total = group.Count(x => x.SubmittedAtUtc >= rangeStartUtc && x.SubmittedAtUtc <= rangeEndUtc),
          Pending = group.Count(x => x.Status == WorkflowStatuses.PendingCheckerApproval && x.SubmittedAtUtc >= rangeStartUtc && x.SubmittedAtUtc <= rangeEndUtc),
          AccountCreated = group.Count(x => x.Status == WorkflowStatuses.AccountCreated && x.SubmittedAtUtc >= rangeStartUtc && x.SubmittedAtUtc <= rangeEndUtc),
          KycReviewed = group.Count(x => x.Status == WorkflowStatuses.KycReviewed && x.SubmittedAtUtc >= rangeStartUtc && x.SubmittedAtUtc <= rangeEndUtc),
          Failed = group.Count(x => x.Status == WorkflowStatuses.Failed && x.SubmittedAtUtc >= rangeStartUtc && x.SubmittedAtUtc <= rangeEndUtc),
          Rejected = group.Count(x => x.Status == WorkflowStatuses.Rejected && x.SubmittedAtUtc >= rangeStartUtc && x.SubmittedAtUtc <= rangeEndUtc),
          TotalOpeningAmount = group.Where(x => x.SubmittedAtUtc >= rangeStartUtc && x.SubmittedAtUtc <= rangeEndUtc).Sum(x => (decimal?)x.OpeningAmount) ?? 0m
        },
        GrandTotal = new
        {
          Total = group.Count(),
          Pending = group.Count(x => x.Status == WorkflowStatuses.PendingCheckerApproval),
          AccountCreated = group.Count(x => x.Status == WorkflowStatuses.AccountCreated),
          KycReviewed = group.Count(x => x.Status == WorkflowStatuses.KycReviewed),
          Failed = group.Count(x => x.Status == WorkflowStatuses.Failed),
          Rejected = group.Count(x => x.Status == WorkflowStatuses.Rejected),
          TotalOpeningAmount = group.Sum(x => (decimal?)x.OpeningAmount) ?? 0m
        }
      })
      .OrderBy(x => x.BranchCode)
      .ToListAsync(cancellationToken);

    var todayBreakdown = await BuildBreakdownAsync(rangeQuery, cancellationToken);
    var grandBreakdown = await BuildBreakdownAsync(baseQuery, cancellationToken);
    var branches = branchGroups.Select(branch => new OnboardingBranchStatsDto(
      branch.BranchCode,
      branchNames.TryGetValue(branch.BranchCode, out var branchName) ? branchName : branch.BranchCode,
      new OnboardingStatusBreakdownDto(
        branch.Today.Total,
        branch.Today.Pending,
        branch.Today.AccountCreated,
        branch.Today.KycReviewed,
        branch.Today.Failed,
        branch.Today.Rejected,
        branch.Today.TotalOpeningAmount
      ),
      new OnboardingStatusBreakdownDto(
        branch.GrandTotal.Total,
        branch.GrandTotal.Pending,
        branch.GrandTotal.AccountCreated,
        branch.GrandTotal.KycReviewed,
        branch.GrandTotal.Failed,
        branch.GrandTotal.Rejected,
        branch.GrandTotal.TotalOpeningAmount
      )
    )).ToList();

    return Ok(new OnboardingDashboardStatsDto(
      "ALL_BRANCHES",
      null,
      rangeStartUtc,
      rangeEndUtc,
      todayBreakdown,
      grandBreakdown,
      branches
    ));
  }

  [HttpGet("{id:guid}")]
  public async Task<ActionResult<OnboardingRecordDto>> Get(Guid id, CancellationToken cancellationToken)
  {
    var record = await dbContext.OnboardingRecords
      .Include(x => x.MakerUser)
      .Include(x => x.CheckerUser)
      .Include(x => x.KycReviewerUser)
      .FirstOrDefaultAsync(x => x.Id == id, cancellationToken);

    if (record is null)
    {
      return NotFound(new { message = "Onboarding record not found." });
    }

    var userId = GetRequiredUserId();
    var role = User.FindFirstValue(ClaimTypes.Role) ?? string.Empty;
    if (role == UserRoles.Maker && record.MakerUserId != userId)
    {
      return Forbid();
    }

    if (role == UserRoles.Checker)
    {
      var checker = await dbContext.Users.FirstAsync(x => x.Id == userId, cancellationToken);
      if (record.BranchCode != checker.BranchCode)
      {
        return Forbid();
      }
    }

    return Ok(Map(record));
  }

  [HttpPost]
  [Authorize(Roles = UserRoles.Maker)]
  public async Task<ActionResult<OnboardingRecordDto>> Submit([FromBody] SubmitApprovalRequest request, CancellationToken cancellationToken)
  {
    request = NormalizeSubmitRequest(request);

    var validationMessage = ValidateSubmitRequest(request);
    if (!string.IsNullOrWhiteSpace(validationMessage))
    {
      return BadRequest(new { message = validationMessage });
    }

    var accountClassDefinitions = await accountClassLookupService.GetAccountClassesAsync(cancellationToken);
    var selectedAccountClass = accountClassDefinitions.FirstOrDefault(option =>
      string.Equals(option.Code, request.AccountClass, StringComparison.OrdinalIgnoreCase));

    if (selectedAccountClass is null)
    {
      return BadRequest(new { message = "The selected account class is no longer available in FCUBS configuration." });
    }

    var requestedOpeningAmount = request.AccountDetails.OpeningAmount > 0
      ? request.AccountDetails.OpeningAmount
      : request.OpeningAmount;

    if (requestedOpeningAmount < selectedAccountClass.MinimumOpeningBalance)
    {
      return BadRequest(new
      {
        message = $"Opening amount for {selectedAccountClass.Code} must be at least {selectedAccountClass.MinimumOpeningBalance:0.##} {selectedAccountClass.CurrencyCode}."
      });
    }

    if (string.Equals(request.AccountDetails.FundingSourceType, "ACCOUNT", StringComparison.OrdinalIgnoreCase))
    {
      var eligibleAccounts = await fundingSourceLookupService.GetEligibleAccountsAsync(request.CustomerNumber, cancellationToken);
      if (!eligibleAccounts.Any(account => string.Equals(account.AccountNumber, request.AccountDetails.FundingSourceValue, StringComparison.OrdinalIgnoreCase)))
      {
        return BadRequest(new { message = "The selected debit account is not eligible for this customer number." });
      }
    }

    var userId = GetRequiredUserId();
    var currentUser = await dbContext.Users.FirstAsync(x => x.Id == userId, cancellationToken);
    var normalizedAccountDetails = request.AccountDetails with
    {
      AccountClassName = selectedAccountClass.Name,
      AccountCode = selectedAccountClass.AccountCode,
      AccountNumberTemplate = BuildAccountReferenceTemplate(currentUser.BranchCode, selectedAccountClass.AccountCode),
      OpeningAmount = requestedOpeningAmount
    };
    var serializedSnapshot = JsonSerializer.Serialize(request.Snapshot, PersistJsonOptions);
    var serializedAdditionalDetails = JsonSerializer.Serialize(request.AdditionalDetails, PersistJsonOptions);
    var serializedCifResponse = request.CifResponse.ValueKind == JsonValueKind.Undefined
      ? "{}"
      : request.CifResponse.GetRawText();
    var serializedAccountDetails = JsonSerializer.Serialize(normalizedAccountDetails, PersistJsonOptions);
    var serializedUploadResponse = request.UploadResponse.ValueKind == JsonValueKind.Undefined
      ? "{}"
      : request.UploadResponse.GetRawText();
    var uploadedDocuments = normalizedAccountDetails.UploadedDocuments ?? Array.Empty<SupportingDocumentDto>();
    var serializedDocuments = JsonSerializer.Serialize(uploadedDocuments, PersistJsonOptions);
    var hasCustomerPhoto = !string.IsNullOrWhiteSpace(normalizedAccountDetails.ImageBase64);
    var hasSignature = !string.IsNullOrWhiteSpace(normalizedAccountDetails.SignatureBase64);
    var hasSupportingDocuments = uploadedDocuments.Any();

    var record = new OnboardingRecord
    {
      CaseReference = BuildCaseReference(request.CustomerNumber),
      Status = WorkflowStatuses.PendingCheckerApproval,
      MakerUserId = userId,
      Fan = request.Fan,
      Psut = request.Psut,
      CustomerNumber = request.CustomerNumber,
      CustomerName = request.CustomerName,
      BranchCode = currentUser.BranchCode,
      AccountClass = selectedAccountClass.Code,
      AccountClassName = selectedAccountClass.Name,
      OpeningAmount = requestedOpeningAmount,
      FundingSourceType = normalizedAccountDetails.FundingSourceType,
      FundingSourceValue = normalizedAccountDetails.FundingSourceValue,
      AccountReference = normalizedAccountDetails.AccountNumberTemplate,
      AssetsReady = hasCustomerPhoto && hasSignature,
      Email = request.AdditionalDetails.Email,
      MobileNumber = request.AdditionalDetails.MobileNumber,
      PlaceOfBirth = request.AdditionalDetails.PlaceOfBirth,
      IdType = request.AdditionalDetails.IdType,
      ResidentIdNumber = request.AdditionalDetails.ResidentIdNumber,
      TinNumber = request.AdditionalDetails.TinNumber,
      HasCustomerPhoto = hasCustomerPhoto,
      HasSignature = hasSignature,
      HasRequiredDocuments = hasSupportingDocuments,
      SnapshotJson = serializedSnapshot,
      AdditionalDetailsJson = serializedAdditionalDetails,
      CifResponseJson = serializedCifResponse,
      AccountDetailsJson = serializedAccountDetails,
      UploadResponseJson = serializedUploadResponse,
      DocumentsJson = serializedDocuments,
      CreatedAtUtc = DateTime.UtcNow,
      UpdatedAtUtc = DateTime.UtcNow,
      SubmittedAtUtc = DateTime.UtcNow
    };

    dbContext.OnboardingRecords.Add(record);
    await dbContext.SaveChangesAsync(cancellationToken);

    await auditService.LogAsync(userId, record.Id, "SUBMIT_FOR_APPROVAL", "OnboardingRecord", record.Id.ToString(), new
    {
      record.CaseReference,
      record.CustomerNumber,
      record.AccountClass,
      record.OpeningAmount
    }, HttpContext.Connection.RemoteIpAddress?.ToString(), cancellationToken);

    record.MakerUser = currentUser;
    return CreatedAtAction(nameof(Get), new { id = record.Id }, Map(record));
  }

  [HttpPost("{id:guid}/approve")]
  [Authorize(Roles = UserRoles.Checker)]
  public async Task<ActionResult<OnboardingRecordDto>> Approve(Guid id, [FromBody] ApproveRequest request, CancellationToken cancellationToken)
  {
    var userId = GetRequiredUserId();
    var checker = await dbContext.Users.FirstAsync(x => x.Id == userId, cancellationToken);
    var record = await dbContext.OnboardingRecords
      .Include(x => x.MakerUser)
      .Include(x => x.CheckerUser)
      .FirstOrDefaultAsync(x => x.Id == id, cancellationToken);

    if (record is null)
    {
      return NotFound(new { message = "Onboarding record not found." });
    }

    if (record.Status != WorkflowStatuses.PendingCheckerApproval)
    {
      return BadRequest(new { message = "Only pending records can be approved." });
    }

    if (record.BranchCode != checker.BranchCode)
    {
      return Forbid();
    }

    var result = await accountApprovalService.CreateAccountAsync(record, cancellationToken);
    record.CheckerUserId = checker.Id;
    record.CheckerUser = checker;
    record.CheckerComment = request.CheckerComment;
    record.ReviewedAtUtc = DateTime.UtcNow;
    record.UpdatedAtUtc = DateTime.UtcNow;
    record.AccountServiceResponseXml = result.RawResponse;
    record.AccountNumber = result.AccountNumber;
    record.LastError = result.Success && result.StatusChangeSuccess ? null : result.Message;
    record.Status = result.Success ? WorkflowStatuses.AccountCreated : WorkflowStatuses.Failed;

    await dbContext.SaveChangesAsync(cancellationToken);

    await auditService.LogAsync(userId, record.Id, "APPROVE_AND_CREATE_ACCOUNT", "OnboardingRecord", record.Id.ToString(), new
    {
      result.Success,
      result.StatusChangeSuccess,
      result.Message,
      result.AccountNumber
    }, HttpContext.Connection.RemoteIpAddress?.ToString(), cancellationToken);

    return Ok(Map(record));
  }

  [HttpPost("{id:guid}/kyc-review")]
  [Authorize(Roles = UserRoles.KycUnit)]
  public async Task<ActionResult<OnboardingRecordDto>> MarkKycReviewed(Guid id, CancellationToken cancellationToken)
  {
    var userId = GetRequiredUserId();
    var reviewer = await dbContext.Users.FirstAsync(x => x.Id == userId, cancellationToken);
    var record = await dbContext.OnboardingRecords
      .Include(x => x.MakerUser)
      .Include(x => x.CheckerUser)
      .Include(x => x.KycReviewerUser)
      .FirstOrDefaultAsync(x => x.Id == id, cancellationToken);

    if (record is null)
    {
      return NotFound(new { message = "Onboarding record not found." });
    }

    if (record.Status != WorkflowStatuses.AccountCreated && record.Status != WorkflowStatuses.KycReviewed)
    {
      return BadRequest(new { message = "Only account-created records can be marked as KYC reviewed." });
    }

    if (record.Status != WorkflowStatuses.KycReviewed)
    {
      record.Status = WorkflowStatuses.KycReviewed;
      record.KycReviewerUserId = reviewer.Id;
      record.KycReviewerUser = reviewer;
      record.KycReviewedAtUtc = DateTime.UtcNow;
      record.UpdatedAtUtc = DateTime.UtcNow;

      await dbContext.SaveChangesAsync(cancellationToken);

      await auditService.LogAsync(userId, record.Id, "MARK_KYC_REVIEWED", "OnboardingRecord", record.Id.ToString(), new
      {
        record.CaseReference,
        record.CustomerNumber,
        record.Status
      }, HttpContext.Connection.RemoteIpAddress?.ToString(), cancellationToken);
    }

    return Ok(Map(record));
  }

  [HttpPost("{id:guid}/reject")]
  [Authorize(Roles = UserRoles.Checker)]
  public async Task<ActionResult<OnboardingRecordDto>> Reject(Guid id, [FromBody] RejectRequest request, CancellationToken cancellationToken)
  {
    var userId = GetRequiredUserId();
    var checker = await dbContext.Users.FirstAsync(x => x.Id == userId, cancellationToken);
    var record = await dbContext.OnboardingRecords
      .Include(x => x.MakerUser)
      .Include(x => x.CheckerUser)
      .FirstOrDefaultAsync(x => x.Id == id, cancellationToken);

    if (record is null)
    {
      return NotFound(new { message = "Onboarding record not found." });
    }

    if (record.Status != WorkflowStatuses.PendingCheckerApproval)
    {
      return BadRequest(new { message = "Only pending records can be rejected." });
    }

    if (record.BranchCode != checker.BranchCode)
    {
      return Forbid();
    }

    record.Status = WorkflowStatuses.Rejected;
    record.CheckerUserId = checker.Id;
    record.CheckerUser = checker;
    record.CheckerComment = request.CheckerComment;
    record.ReviewedAtUtc = DateTime.UtcNow;
    record.UpdatedAtUtc = DateTime.UtcNow;
    record.LastError = request.CheckerComment;

    await dbContext.SaveChangesAsync(cancellationToken);

    await auditService.LogAsync(userId, record.Id, "REJECT_APPROVAL", "OnboardingRecord", record.Id.ToString(), new
    {
      request.CheckerComment
    }, HttpContext.Connection.RemoteIpAddress?.ToString(), cancellationToken);

    return Ok(Map(record));
  }

  private Guid GetRequiredUserId()
  {
    return Guid.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!);
  }

  private static string BuildCaseReference(string customerNumber)
  {
    return $"ONB-{customerNumber}-{DateTime.UtcNow:ddHHmmss}";
  }

  private static string BuildAccountReferenceTemplate(string branchCode, string accountCode)
  {
    var template = $"{branchCode}{accountCode}CCCCS";
    return template.Length <= 20 ? template : template[..20];
  }

  private static OnboardingRecordDto Map(OnboardingRecord record)
  {
    return new OnboardingRecordDto(
      record.Id,
      record.CaseReference,
      record.Status,
      record.CustomerNumber,
      record.CustomerName,
      record.BranchCode,
      record.AccountClass,
      record.AccountClassName,
      record.OpeningAmount,
      record.FundingSourceType,
      record.FundingSourceValue,
      record.AccountReference,
      record.AssetsReady,
      record.Email,
      record.MobileNumber,
      record.PlaceOfBirth,
      record.IdType,
      record.ResidentIdNumber,
      record.TinNumber,
      record.HasCustomerPhoto,
      record.HasSignature,
      record.HasRequiredDocuments,
      record.MakerUser?.Username ?? string.Empty,
      record.MakerUser?.FullName ?? record.MakerUserId.ToString(),
      record.SubmittedAtUtc,
      record.CheckerUser?.Username,
      record.CheckerUser?.FullName,
      record.ReviewedAtUtc,
      record.KycReviewerUser?.Username,
      record.KycReviewerUser?.FullName,
      record.KycReviewedAtUtc,
      record.CheckerComment,
      record.AccountNumber,
      record.LastError,
      record.DocumentsJson,
      record.SnapshotJson,
      record.AdditionalDetailsJson,
      record.CifResponseJson,
      record.AccountDetailsJson,
      record.UploadResponseJson
    );
  }

  private static IQueryable<OnboardingRecord> ApplyReportScope(IQueryable<OnboardingRecord> query, AppUser currentUser, string role)
  {
    if (role == UserRoles.KycUnit)
    {
      return query.Where(x => x.Status == WorkflowStatuses.AccountCreated || x.Status == WorkflowStatuses.KycReviewed);
    }

    if (role == UserRoles.Maker || role == UserRoles.Checker)
    {
      return query.Where(x => x.BranchCode == currentUser.BranchCode);
    }

    return query;
  }

  private static IQueryable<OnboardingRecord> ApplySorting(IQueryable<OnboardingRecord> query, string? sortBy, string? sortDirection)
  {
    var descending = !string.Equals(sortDirection, "asc", StringComparison.OrdinalIgnoreCase);
    return (sortBy ?? string.Empty).ToLowerInvariant() switch
    {
      "customername" => descending ? query.OrderByDescending(x => x.CustomerName) : query.OrderBy(x => x.CustomerName),
      "customernumber" => descending ? query.OrderByDescending(x => x.CustomerNumber) : query.OrderBy(x => x.CustomerNumber),
      "accountnumber" => descending ? query.OrderByDescending(x => x.AccountNumber) : query.OrderBy(x => x.AccountNumber),
      "reviewedatutc" => descending ? query.OrderByDescending(x => x.ReviewedAtUtc) : query.OrderBy(x => x.ReviewedAtUtc),
      "kycreviewedatutc" => descending ? query.OrderByDescending(x => x.KycReviewedAtUtc) : query.OrderBy(x => x.KycReviewedAtUtc),
      _ => descending ? query.OrderByDescending(x => x.SubmittedAtUtc) : query.OrderBy(x => x.SubmittedAtUtc)
    };
  }

  private static async Task<OnboardingStatusBreakdownDto> BuildBreakdownAsync(IQueryable<OnboardingRecord> query, CancellationToken cancellationToken)
  {
    var total = await query.CountAsync(cancellationToken);
    var pending = await query.CountAsync(x => x.Status == WorkflowStatuses.PendingCheckerApproval, cancellationToken);
    var accountCreated = await query.CountAsync(x => x.Status == WorkflowStatuses.AccountCreated, cancellationToken);
    var kycReviewed = await query.CountAsync(x => x.Status == WorkflowStatuses.KycReviewed, cancellationToken);
    var failed = await query.CountAsync(x => x.Status == WorkflowStatuses.Failed, cancellationToken);
    var rejected = await query.CountAsync(x => x.Status == WorkflowStatuses.Rejected, cancellationToken);
    var totalOpeningAmount = await query.SumAsync(x => (decimal?)x.OpeningAmount, cancellationToken) ?? 0m;

    return new OnboardingStatusBreakdownDto(total, pending, accountCreated, kycReviewed, failed, rejected, totalOpeningAmount);
  }

  private static DateTime EnsureUtc(DateTime value)
  {
    return value.Kind switch
    {
      DateTimeKind.Utc => value,
      DateTimeKind.Local => value.ToUniversalTime(),
      _ => DateTime.SpecifyKind(value, DateTimeKind.Utc)
    };
  }

  private static string? ValidateSubmitRequest(SubmitApprovalRequest request)
  {
    var monthlyIncome = request.AdditionalDetails.MonthlyIncome;
    var requiresMonthlyIncome = !request.Snapshot.Minor;

    if (string.IsNullOrWhiteSpace(request.Fan) ||
        string.IsNullOrWhiteSpace(request.Psut) ||
        string.IsNullOrWhiteSpace(request.CustomerNumber) ||
        string.IsNullOrWhiteSpace(request.CustomerName))
    {
      return "Customer verification data is incomplete. Please restart the onboarding flow from FAN verification.";
    }

    if ((requiresMonthlyIncome && (!monthlyIncome.HasValue || monthlyIncome.Value <= 0)) ||
        string.IsNullOrWhiteSpace(request.AdditionalDetails.MotherName) ||
        string.IsNullOrWhiteSpace(request.AdditionalDetails.Occupation) ||
        string.IsNullOrWhiteSpace(request.AdditionalDetails.Employer) ||
        string.IsNullOrWhiteSpace(request.AdditionalDetails.WorkPosition) ||
        string.IsNullOrWhiteSpace(request.AdditionalDetails.Title) ||
        string.IsNullOrWhiteSpace(request.AdditionalDetails.MaritalStatus) ||
        string.IsNullOrWhiteSpace(request.AdditionalDetails.StaffStatus) ||
        string.IsNullOrWhiteSpace(request.AdditionalDetails.MobileNumber) ||
        string.IsNullOrWhiteSpace(request.AdditionalDetails.PlaceOfBirth) ||
        string.IsNullOrWhiteSpace(request.AdditionalDetails.IdType))
    {
      return "Mandatory KYC fields are incomplete. Please complete the customer details form before submission.";
    }

    if (!string.IsNullOrWhiteSpace(request.AdditionalDetails.Email) &&
        !System.Text.RegularExpressions.Regex.IsMatch(request.AdditionalDetails.Email, @"^[^@\s]+@[^@\s]+\.[^@\s]+$"))
    {
      return "If email is provided, it must be a valid email address.";
    }

    if (!System.Text.RegularExpressions.Regex.IsMatch(request.AdditionalDetails.MobileNumber, @"^(?:\+?251|0)?9\d{8}$"))
    {
      return "A valid Ethiopian mobile number is required before submission.";
    }

    if (request.Snapshot.Minor && string.IsNullOrWhiteSpace(request.AdditionalDetails.GuardianName))
    {
      return "Guardian name is required for minor customer onboarding.";
    }

    if (string.Equals(request.AccountClass, "SSPI", StringComparison.OrdinalIgnoreCase) &&
        string.IsNullOrWhiteSpace(request.AdditionalDetails.TinNumber))
    {
      return "TIN number is required for Special Saving account requests.";
    }

    var fundingSourceType = (request.AccountDetails.FundingSourceType ?? string.Empty).Trim().ToUpperInvariant();
    var fundingSourceValue = (request.AccountDetails.FundingSourceValue ?? string.Empty).Trim();
    if (fundingSourceType == "ACCOUNT" && !System.Text.RegularExpressions.Regex.IsMatch(fundingSourceValue, @"^\d{13}$"))
    {
      return "Debit account number must be exactly 13 digits when the funding source is another account.";
    }

    if (fundingSourceType == "GL" && !System.Text.RegularExpressions.Regex.IsMatch(fundingSourceValue, @"^\d{7}$"))
    {
      return "Debit GL number must be exactly 7 digits when the funding source is GL.";
    }

    if (string.IsNullOrWhiteSpace(request.AccountDetails.ImageBase64) ||
        string.IsNullOrWhiteSpace(request.AccountDetails.SignatureBase64))
    {
      return "Customer photo and signature must be uploaded before submission.";
    }

    if (request.UploadResponse.ValueKind is JsonValueKind.Undefined or JsonValueKind.Null)
    {
      return "Customer image and signature upload confirmation is missing.";
    }

    return null;
  }

  private static SubmitApprovalRequest NormalizeSubmitRequest(SubmitApprovalRequest request)
  {
    var normalizedIncome = request.Snapshot.Minor && (!request.AdditionalDetails.MonthlyIncome.HasValue || request.AdditionalDetails.MonthlyIncome.Value <= 0)
      ? null
      : request.AdditionalDetails.MonthlyIncome;

    var documentReference = string.IsNullOrWhiteSpace(request.AdditionalDetails.DmsReferenceNumber)
      ? GenerateInternalDocumentReference()
      : request.AdditionalDetails.DmsReferenceNumber.Trim();

    return request with
    {
      AdditionalDetails = request.AdditionalDetails with
      {
        MonthlyIncome = normalizedIncome,
        DmsReferenceNumber = documentReference
      }
    };
  }

  private static string GenerateInternalDocumentReference()
  {
    var timestamp = DateTime.UtcNow.ToString("yyyyMMddHHmmss");
    var suffix = Guid.NewGuid().ToString("N")[..8].ToUpperInvariant();
    return $"DOC-{timestamp}-{suffix}";
  }
}
