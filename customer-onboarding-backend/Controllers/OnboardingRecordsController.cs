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
  IFundingSourceLookupService fundingSourceLookupService,
  IAccountClassLookupService accountClassLookupService,
  IOnboardingScreeningService onboardingScreeningService,
  IOnboardingFulfillmentService onboardingFulfillmentService
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
        (x.Status == WorkflowStatuses.KycApproved || x.Status == WorkflowStatuses.AccountCreated || x.Status == WorkflowStatuses.KycReviewed))
      .OrderByDescending(x => x.KycApprovedAtUtc ?? x.KycReviewedAtUtc ?? x.ReviewedAtUtc ?? x.UpdatedAtUtc)
      .ToListAsync(cancellationToken);

    return Ok(records.Select(Map));
  }

  [HttpGet("kyc/pending")]
  [Authorize(Roles = UserRoles.KycUnit)]
  public async Task<ActionResult<IEnumerable<OnboardingRecordDto>>> KycPending(CancellationToken cancellationToken)
  {
    var records = await dbContext.OnboardingRecords
      .Include(x => x.MakerUser)
      .Include(x => x.KycReviewerUser)
      .Where(x => x.Status == WorkflowStatuses.PendingKycAuthorization ||
                  x.Status == WorkflowStatuses.PendingCheckerApproval ||
                  x.Status == WorkflowStatuses.FulfillmentFailed ||
                  x.Status == WorkflowStatuses.DuplicateCifBlocked)
      .OrderByDescending(x => x.SubmittedAtUtc)
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
          Pending = group.Count(x => (x.Status == WorkflowStatuses.PendingKycAuthorization || x.Status == WorkflowStatuses.PendingCheckerApproval) && x.SubmittedAtUtc >= rangeStartUtc && x.SubmittedAtUtc <= rangeEndUtc),
          AccountCreated = group.Count(x => (x.Status == WorkflowStatuses.AccountCreated || x.Status == WorkflowStatuses.KycApproved) && x.SubmittedAtUtc >= rangeStartUtc && x.SubmittedAtUtc <= rangeEndUtc),
          KycReviewed = group.Count(x => (x.Status == WorkflowStatuses.KycReviewed || x.Status == WorkflowStatuses.KycApproved) && x.SubmittedAtUtc >= rangeStartUtc && x.SubmittedAtUtc <= rangeEndUtc),
          Failed = group.Count(x => (x.Status == WorkflowStatuses.Failed || x.Status == WorkflowStatuses.FulfillmentFailed || x.Status == WorkflowStatuses.DuplicateCifBlocked) && x.SubmittedAtUtc >= rangeStartUtc && x.SubmittedAtUtc <= rangeEndUtc),
          Rejected = group.Count(x => (x.Status == WorkflowStatuses.Rejected || x.Status == WorkflowStatuses.KycRejected) && x.SubmittedAtUtc >= rangeStartUtc && x.SubmittedAtUtc <= rangeEndUtc),
          TotalOpeningAmount = group.Where(x => x.SubmittedAtUtc >= rangeStartUtc && x.SubmittedAtUtc <= rangeEndUtc).Sum(x => (decimal?)x.OpeningAmount) ?? 0m
        },
        GrandTotal = new
        {
          Total = group.Count(),
          Pending = group.Count(x => x.Status == WorkflowStatuses.PendingKycAuthorization || x.Status == WorkflowStatuses.PendingCheckerApproval),
          AccountCreated = group.Count(x => x.Status == WorkflowStatuses.AccountCreated || x.Status == WorkflowStatuses.KycApproved),
          KycReviewed = group.Count(x => x.Status == WorkflowStatuses.KycReviewed || x.Status == WorkflowStatuses.KycApproved),
          Failed = group.Count(x => x.Status == WorkflowStatuses.Failed || x.Status == WorkflowStatuses.FulfillmentFailed || x.Status == WorkflowStatuses.DuplicateCifBlocked),
          Rejected = group.Count(x => x.Status == WorkflowStatuses.Rejected || x.Status == WorkflowStatuses.KycRejected),
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

    if (requestedOpeningAmount > 1000m)
    {
      return BadRequest(new { message = "Initial opening deposit cannot exceed ETB 1,000 before KYC approval." });
    }

    var userId = GetRequiredUserId();
    var currentUser = await dbContext.Users.FirstAsync(x => x.Id == userId, cancellationToken);
    var duplicateNationalId = await dbContext.OnboardingRecords.AnyAsync(item =>
      item.Psut == request.Psut &&
      item.Status != WorkflowStatuses.KycRejected &&
      item.Status != WorkflowStatuses.Rejected,
      cancellationToken);
    if (duplicateNationalId)
    {
      return Conflict(new { message = "This National ID already has an active or completed onboarding record. Review the existing customer before continuing." });
    }

    var normalizedAccountDetails = request.AccountDetails with
    {
      AccountClassName = selectedAccountClass.Name,
      AccountCode = selectedAccountClass.AccountCode,
      AccountNumberTemplate = BuildAccountReferenceTemplate(currentUser.BranchCode, selectedAccountClass.AccountCode),
      OpeningAmount = requestedOpeningAmount
    };
    var serializedSnapshot = JsonSerializer.Serialize(request.Snapshot, PersistJsonOptions);
    var serializedAdditionalDetails = JsonSerializer.Serialize(request.AdditionalDetails, PersistJsonOptions);
    var serializedAccountDetails = JsonSerializer.Serialize(normalizedAccountDetails, PersistJsonOptions);
    var uploadedDocuments = normalizedAccountDetails.UploadedDocuments ?? Array.Empty<SupportingDocumentDto>();
    var serializedDocuments = JsonSerializer.Serialize(uploadedDocuments, PersistJsonOptions);
    var hasCustomerPhoto = !string.IsNullOrWhiteSpace(normalizedAccountDetails.ImageBase64);
    var hasSignature = !string.IsNullOrWhiteSpace(normalizedAccountDetails.SignatureBase64);
    var hasSupportingDocuments = uploadedDocuments.Any();

    var record = new OnboardingRecord
    {
      CaseReference = BuildCaseReference(request.Fan),
      TemporaryReference = BuildTemporaryReference(request.Fan),
      Status = WorkflowStatuses.PendingKycAuthorization,
      MakerUserId = userId,
      Fan = request.Fan,
      Psut = request.Psut,
      CustomerNumber = BuildTemporaryReference(request.Fan),
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
      CifResponseJson = "{}",
      AccountDetailsJson = serializedAccountDetails,
      UploadResponseJson = "{}",
      DocumentsJson = serializedDocuments,
      CreatedAtUtc = DateTime.UtcNow,
      UpdatedAtUtc = DateTime.UtcNow,
      SubmittedAtUtc = DateTime.UtcNow
    };

    var screening = await onboardingScreeningService.EvaluateAsync(record, cancellationToken);
    record.ScreeningStatus = screening.Status;
    record.HasRestrictiveScreeningMatch = screening.HasRestrictiveMatch;
    record.ScreeningDetailsJson = JsonSerializer.Serialize(screening, PersistJsonOptions);

    dbContext.OnboardingRecords.Add(record);
    await dbContext.SaveChangesAsync(cancellationToken);

    await auditService.LogAsync(userId, record.Id, "SUBMIT_FOR_KYC_AUTHORIZATION", "OnboardingRecord", record.Id.ToString(), new
    {
      record.CaseReference,
      record.TemporaryReference,
      record.AccountClass,
      record.OpeningAmount,
      record.ScreeningStatus
    }, HttpContext.Connection.RemoteIpAddress?.ToString(), cancellationToken);

    record.MakerUser = currentUser;
    return CreatedAtAction(nameof(Get), new { id = record.Id }, Map(record));
  }

  [HttpPost("{id:guid}/approve")]
  [Authorize(Roles = UserRoles.Checker)]
  public Task<ActionResult<OnboardingRecordDto>> Approve(Guid id, [FromBody] ApproveRequest request, CancellationToken cancellationToken)
  {
    return Task.FromResult<ActionResult<OnboardingRecordDto>>(BadRequest(new { message = "Onboarding approval is performed by the KYC Unit. This checker action is no longer available." }));
  }

  [HttpPost("{id:guid}/kyc/approve")]
  [Authorize(Roles = UserRoles.KycUnit)]
  public async Task<ActionResult<OnboardingRecordDto>> KycApprove(Guid id, [FromBody] KycDecisionRequest request, CancellationToken cancellationToken)
  {
    var userId = GetRequiredUserId();
    var reviewer = await dbContext.Users.FirstAsync(x => x.Id == userId, cancellationToken);
    var record = await dbContext.OnboardingRecords
      .Include(x => x.MakerUser)
      .Include(x => x.KycReviewerUser)
      .FirstOrDefaultAsync(x => x.Id == id, cancellationToken);

    if (record is null)
    {
      return NotFound(new { message = "Onboarding record not found." });
    }

    if (record.Status != WorkflowStatuses.PendingKycAuthorization &&
        record.Status != WorkflowStatuses.PendingCheckerApproval &&
        record.Status != WorkflowStatuses.FulfillmentFailed &&
        record.Status != WorkflowStatuses.DuplicateCifBlocked)
    {
      return BadRequest(new { message = "This record is not available for KYC authorization." });
    }

    var screening = await onboardingScreeningService.EvaluateAsync(record, cancellationToken);
    record.ScreeningStatus = screening.Status;
    record.HasRestrictiveScreeningMatch = screening.HasRestrictiveMatch;
    record.ScreeningDetailsJson = JsonSerializer.Serialize(screening, PersistJsonOptions);
    record.KycReviewerUserId = reviewer.Id;
    record.KycReviewerUser = reviewer;
    record.KycComment = request.KycComment?.Trim();
    record.UpdatedAtUtc = DateTime.UtcNow;

    if (screening.HasRestrictiveMatch)
    {
      await dbContext.SaveChangesAsync(cancellationToken);
      await auditService.LogAsync(userId, record.Id, "KYC_AUTHORIZATION_BLOCKED_BY_SCREENING", "OnboardingRecord", record.Id.ToString(), new
      {
        record.CaseReference,
        record.ScreeningStatus,
        screening.Matches
      }, HttpContext.Connection.RemoteIpAddress?.ToString(), cancellationToken);

      return BadRequest(new { message = "KYC authorization is blocked because a restrictive screening match was found." });
    }

    record.Status = WorkflowStatuses.KycProcessing;
    await dbContext.SaveChangesAsync(cancellationToken);

    var fulfillment = await onboardingFulfillmentService.FulfillAsync(record, cancellationToken);
    record.CifResponseJson = string.IsNullOrWhiteSpace(fulfillment.CifResponse) ? record.CifResponseJson : fulfillment.CifResponse;
    record.UploadResponseJson = string.IsNullOrWhiteSpace(fulfillment.UploadResponse) ? record.UploadResponseJson : fulfillment.UploadResponse;
    record.AccountServiceResponseXml = string.IsNullOrWhiteSpace(fulfillment.AccountResponse) ? record.AccountServiceResponseXml : fulfillment.AccountResponse;
    record.CustomerNumber = string.IsNullOrWhiteSpace(fulfillment.CustomerNumber) ? record.CustomerNumber : fulfillment.CustomerNumber;
    record.AccountNumber = string.IsNullOrWhiteSpace(fulfillment.AccountNumber) ? record.AccountNumber : fulfillment.AccountNumber;
    record.LastError = fulfillment.Success ? null : fulfillment.Message;
    record.UpdatedAtUtc = DateTime.UtcNow;
    record.Status = fulfillment.Success
      ? WorkflowStatuses.KycApproved
      : (fulfillment.IsDuplicateCif ? WorkflowStatuses.DuplicateCifBlocked : WorkflowStatuses.FulfillmentFailed);
    if (fulfillment.Success)
    {
      record.KycReference ??= BuildKycReference(record.BranchCode);
      record.KycApprovedAtUtc = DateTime.UtcNow;
      record.KycReviewedAtUtc = record.KycApprovedAtUtc;
    }

    await dbContext.SaveChangesAsync(cancellationToken);
    await auditService.LogAsync(userId, record.Id, fulfillment.Success ? "KYC_APPROVE_AND_FULFILL" : "KYC_FULFILLMENT_FAILED", "OnboardingRecord", record.Id.ToString(), new
    {
      fulfillment.Success,
      fulfillment.IsDuplicateCif,
      fulfillment.Message,
      fulfillment.CustomerNumber,
      fulfillment.AccountNumber,
      record.KycReference
    }, HttpContext.Connection.RemoteIpAddress?.ToString(), cancellationToken);

    return Ok(Map(record));
  }

  [HttpPost("{id:guid}/kyc/reject")]
  [Authorize(Roles = UserRoles.KycUnit)]
  public async Task<ActionResult<OnboardingRecordDto>> KycReject(Guid id, [FromBody] KycDecisionRequest request, CancellationToken cancellationToken)
  {
    var userId = GetRequiredUserId();
    var reviewer = await dbContext.Users.FirstAsync(x => x.Id == userId, cancellationToken);
    var record = await dbContext.OnboardingRecords
      .Include(x => x.MakerUser)
      .Include(x => x.KycReviewerUser)
      .FirstOrDefaultAsync(x => x.Id == id, cancellationToken);

    if (record is null)
    {
      return NotFound(new { message = "Onboarding record not found." });
    }

    if (string.IsNullOrWhiteSpace(request.KycComment))
    {
      return BadRequest(new { message = "A KYC rejection reason is required." });
    }

    if (record.Status != WorkflowStatuses.PendingKycAuthorization && record.Status != WorkflowStatuses.PendingCheckerApproval)
    {
      return BadRequest(new { message = "Only pending KYC records can be rejected." });
    }

    // Option A: nothing has been posted to FCUBS before KYC approval, so no external reversal is needed.
    record.Status = WorkflowStatuses.KycRejected;
    record.KycReviewerUserId = reviewer.Id;
    record.KycReviewerUser = reviewer;
    record.KycComment = request.KycComment.Trim();
    record.KycRejectedAtUtc = DateTime.UtcNow;
    record.UpdatedAtUtc = DateTime.UtcNow;
    record.LastError = request.KycComment.Trim();

    await dbContext.SaveChangesAsync(cancellationToken);

    await auditService.LogAsync(userId, record.Id, "KYC_REJECT", "OnboardingRecord", record.Id.ToString(), new
    {
      request.KycComment
    }, HttpContext.Connection.RemoteIpAddress?.ToString(), cancellationToken);

    return Ok(Map(record));
  }

  private Guid GetRequiredUserId()
  {
    return Guid.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!);
  }

  private static string BuildCaseReference(string fan)
  {
    var suffix = string.IsNullOrWhiteSpace(fan) ? "CUSTOMER" : fan.Trim();
    return $"ONB-{suffix}-{DateTime.UtcNow:ddHHmmss}";
  }

  private static string BuildTemporaryReference(string fan)
  {
    var suffix = string.IsNullOrWhiteSpace(fan) ? Guid.NewGuid().ToString("N")[..8].ToUpperInvariant() : fan.Trim();
    return $"TMP-{suffix}-{DateTime.UtcNow:yyyyMMddHHmmss}";
  }

  private static string BuildKycReference(string branchCode) => $"KYC-{branchCode}-{DateTime.UtcNow:yyyyMMddHHmmss}-{Guid.NewGuid().ToString("N")[..6].ToUpperInvariant()}";

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
      record.UploadResponseJson,
      record.TemporaryReference,
      record.ScreeningStatus,
      record.HasRestrictiveScreeningMatch,
      record.ScreeningDetailsJson,
      record.KycReference,
      record.KycComment,
      record.KycApprovedAtUtc,
      record.KycRejectedAtUtc
    );
  }

  private static IQueryable<OnboardingRecord> ApplyReportScope(IQueryable<OnboardingRecord> query, AppUser currentUser, string role)
  {
    if (role == UserRoles.KycUnit)
    {
      return query.Where(x => x.Status == WorkflowStatuses.PendingKycAuthorization ||
                              x.Status == WorkflowStatuses.PendingCheckerApproval ||
                              x.Status == WorkflowStatuses.KycProcessing ||
                              x.Status == WorkflowStatuses.KycApproved ||
                              x.Status == WorkflowStatuses.KycRejected ||
                              x.Status == WorkflowStatuses.FulfillmentFailed ||
                              x.Status == WorkflowStatuses.DuplicateCifBlocked ||
                              x.Status == WorkflowStatuses.AccountCreated ||
                              x.Status == WorkflowStatuses.KycReviewed);
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
    var pending = await query.CountAsync(x => x.Status == WorkflowStatuses.PendingKycAuthorization || x.Status == WorkflowStatuses.PendingCheckerApproval, cancellationToken);
    var accountCreated = await query.CountAsync(x => x.Status == WorkflowStatuses.AccountCreated || x.Status == WorkflowStatuses.KycApproved, cancellationToken);
    var kycReviewed = await query.CountAsync(x => x.Status == WorkflowStatuses.KycReviewed || x.Status == WorkflowStatuses.KycApproved, cancellationToken);
    var failed = await query.CountAsync(x => x.Status == WorkflowStatuses.Failed || x.Status == WorkflowStatuses.FulfillmentFailed || x.Status == WorkflowStatuses.DuplicateCifBlocked, cancellationToken);
    var rejected = await query.CountAsync(x => x.Status == WorkflowStatuses.Rejected || x.Status == WorkflowStatuses.KycRejected, cancellationToken);
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
