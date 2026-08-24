using System.Security.Claims;
using System.Text.Json;
using CustomerOnboarding.Backend.Data;
using CustomerOnboarding.Backend.Dtos;
using CustomerOnboarding.Backend.Models;
using CustomerOnboarding.Backend.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace CustomerOnboarding.Backend.Controllers;

[ApiController]
[Route("api/core/resource-mobilization")]
[Authorize]
public class ResourceMobilizationController(
  AppDbContext dbContext,
  IResourceMobilizationService resourceMobilizationService,
  IAuditService auditService,
  ILogger<ResourceMobilizationController> logger
) : ControllerBase
{
  private static readonly string[] AllowedProductTypes = ["DEMAND", "SAVING", "IFB"];

  [HttpGet("employees")]
  [Authorize(Roles = $"{UserRoles.Maker},{UserRoles.Checker},{UserRoles.Admin},{UserRoles.SystemAdmin},{UserRoles.ReportViewer}")]
  public async Task<ActionResult<IReadOnlyList<ResourceMobilizationEmployeeSearchResultDto>>> SearchEmployees(
    [FromQuery] string? search,
    [FromQuery] int limit = 20,
    CancellationToken cancellationToken = default)
  {
    var items = await resourceMobilizationService.SearchEmployeesAsync(search, limit, cancellationToken);
    return Ok(items);
  }

  [HttpPost("transactions/search")]
  [Authorize(Roles = UserRoles.Maker)]
  public async Task<ActionResult<IReadOnlyList<ResourceMobilizationTransactionDto>>> SearchTransactions(
    [FromBody] ResourceMobilizationTransactionLookupRequest request,
    CancellationToken cancellationToken)
  {
    try
    {
      var transactionReferenceNo = (request.TransactionReferenceNo ?? string.Empty).Trim();
      var accountNumber = (request.AccountNumber ?? string.Empty).Trim();

      if (string.IsNullOrWhiteSpace(transactionReferenceNo) && string.IsNullOrWhiteSpace(accountNumber))
      {
        return BadRequest(new { message = "Please provide either the transaction reference or the depositor account number." });
      }

      if (!string.IsNullOrWhiteSpace(accountNumber) && accountNumber.Length < 10)
      {
        return BadRequest(new { message = "Please provide a valid depositor account number." });
      }

      if (!string.IsNullOrWhiteSpace(transactionReferenceNo))
      {
        var existing = await dbContext.ResourceMobilizationRecords
          .AsNoTracking()
          .Where(x => x.TransactionReferenceNo == transactionReferenceNo)
          .OrderByDescending(x => x.UpdatedAt)
          .ThenByDescending(x => x.CreatedAt)
          .Select(x => new ResourceMobilizationRegistrationStatusDto(
            true,
            x.Id,
            x.RegistrationReference,
            x.Status,
            x.EmployeeReference,
            x.EmployeeFullName,
            x.CreatedAt))
          .FirstOrDefaultAsync(cancellationToken);

        if (existing is not null)
        {
          return Conflict(new
          {
            message = "This deposit transaction is already registered for resource mobilization.",
            existing.IsRegistered,
            existing.ExistingRecordId,
            existing.ExistingRegistrationReference,
            existing.ExistingStatus,
            existing.ExistingEmployeeReference,
            existing.ExistingEmployeeFullName,
            existing.CreatedAt
          });
        }
      }

      var results = await resourceMobilizationService.SearchTransactionsAsync(request, cancellationToken);
      return Ok(results);
    }
    catch (Exception ex)
    {
      logger.LogError(ex, "Resource mobilization transaction search failed. Reference={TransactionReferenceNo}, Account={AccountNumber}",
        request.TransactionReferenceNo, request.AccountNumber);
      return StatusCode(500, new
      {
        message = $"Deposit transaction search failed. {ex.Message}"
      });
    }
  }

  [HttpPost("submit")]
  [Authorize(Roles = UserRoles.Maker)]
  public async Task<ActionResult<ResourceMobilizationRecordDto>> Submit(
    [FromBody] SubmitResourceMobilizationRequest request,
    CancellationToken cancellationToken)
  {
    try
    {
      var currentUser = await GetCurrentUserAsync(cancellationToken);
      var selectedEmployeeIds = (request.EmployeeDirectoryEntryIds ?? Array.Empty<string>())
        .Select(x => (x ?? string.Empty).Trim())
        .Where(x => !string.IsNullOrWhiteSpace(x))
        .Distinct(StringComparer.OrdinalIgnoreCase)
        .ToList();

      if (selectedEmployeeIds.Count == 0 && !string.IsNullOrWhiteSpace(request.EmployeeDirectoryEntryId))
      {
        selectedEmployeeIds.Add(request.EmployeeDirectoryEntryId.Trim());
      }

      var isJointRegistration = request.IsJointRegistration || selectedEmployeeIds.Count > 1;
      if (!isJointRegistration && selectedEmployeeIds.Count != 1)
      {
        return BadRequest(new { message = "Select one employee for a single registration." });
      }

      if (isJointRegistration && (selectedEmployeeIds.Count < 2 || selectedEmployeeIds.Count > 3))
      {
        return BadRequest(new { message = "Joint registration requires 2 or 3 employees." });
      }

      var employees = new List<ResourceMobilizationEmployeeSearchResultDto>();
      foreach (var selectedEmployeeId in selectedEmployeeIds)
      {
        var employee = await resourceMobilizationService.GetEmployeeByIdAsync(selectedEmployeeId, cancellationToken);
        if (employee is null || !employee.IsActive)
        {
          return BadRequest(new { message = "Select only active employees from the directory." });
        }

        employees.Add(employee);
      }

      var normalizedProductType = NormalizeProductType(request.DepositProductType);
      if (normalizedProductType is null)
      {
        return BadRequest(new { message = "Select a valid deposit product type." });
      }

      if (request.MonthlyTargetAmount < 0)
      {
        return BadRequest(new { message = "Monthly target cannot be negative." });
      }

      if (request.NewAccountCount < 0)
      {
        return BadRequest(new { message = "New account count cannot be negative." });
      }

      var transactionReferenceNo = (request.TransactionReferenceNo ?? string.Empty).Trim();
      var accountNumber = (request.AccountNumber ?? string.Empty).Trim();
      if (string.IsNullOrWhiteSpace(transactionReferenceNo) || string.IsNullOrWhiteSpace(accountNumber))
      {
        return BadRequest(new { message = "Select a CBS deposit transaction first." });
      }

      var existing = await dbContext.ResourceMobilizationRecords
        .AsNoTracking()
        .Where(x => x.TransactionReferenceNo == transactionReferenceNo)
        .OrderByDescending(x => x.UpdatedAt)
        .ThenByDescending(x => x.CreatedAt)
        .FirstOrDefaultAsync(cancellationToken);
      if (existing is not null)
      {
        return Conflict(new
        {
          message = $"This deposit is already registered with status {existing.Status}.",
          existingRecordId = existing.Id,
          registrationReference = existing.RegistrationReference,
          existingStatus = existing.Status,
          existingEmployee = existing.EmployeeFullName
        });
      }

      var transaction = await resourceMobilizationService.GetTransactionAsync(transactionReferenceNo, accountNumber, cancellationToken);
      if (transaction is null)
      {
        return BadRequest(new { message = "Re-select the CBS transaction and try again." });
      }

      var customerName = !string.IsNullOrWhiteSpace(transaction.CustomerName)
        ? transaction.CustomerName.Trim()
        : (request.DepositorCustomerName ?? string.Empty).Trim();
      if (string.IsNullOrWhiteSpace(customerName))
      {
        return BadRequest(new { message = "Depositor name was not returned from CBS." });
      }

      var registrationBatchReference = BuildRegistrationBatchReference();
      var splitAmounts = SplitAmountEvenly(transaction.Amount, employees.Count);
      var records = new List<ResourceMobilizationRecord>();

      for (var index = 0; index < employees.Count; index += 1)
      {
        var employee = employees[index];
        var monthlyTargetAmount = !isJointRegistration && employee.HasExistingRegistration
          ? employee.ExistingMonthlyTargetAmount ?? request.MonthlyTargetAmount
          : request.MonthlyTargetAmount;

        var newAccountCount = !isJointRegistration && employee.HasExistingRegistration
          ? employee.ExistingNewAccountCount ?? request.NewAccountCount
          : request.NewAccountCount;

        records.Add(new ResourceMobilizationRecord
        {
          RegistrationReference = BuildRegistrationReference(registrationBatchReference, index + 1, employees.Count),
          RegistrationBatchReference = registrationBatchReference,
          EmployeeDirectoryEntryId = Guid.TryParse(employee.Id, out var employeeId) ? employeeId : null,
          IsJointRegistration = isJointRegistration,
          JointParticipantCount = employees.Count,
          JointSequenceNumber = index + 1,
          EmployeeReference = Fit(employee.EmployeeReference, 96),
          EmployeeFullName = Fit(employee.FullName, 220),
          EmployeePhoneNumber = FitNullable(employee.PhoneNumber, 32),
          EmployeeBranchCode = FitNullable(employee.BranchCode, 32),
          EmployeeBranchName = FitNullable(employee.BranchName, 220),
          EmployeeDepartmentName = FitNullable(employee.DepartmentName, 220),
          EmployeePositionName = FitNullable(employee.PositionName, 220),
          EmployeeClassification = FitNullable(employee.Classification, 80),
          MonthlyTargetAmount = monthlyTargetAmount,
          DepositProductType = normalizedProductType,
          SourceTransactionAmount = transaction.Amount,
          TotalDepositMobilized = splitAmounts[index],
          NewAccountCount = newAccountCount,
          DepositorCustomerName = Fit(customerName, 220),
          DepositorCustomerNumber = FitNullable(transaction.CustomerNumber, 40),
          DepositorAccountNumber = Fit(transaction.AccountNumber, 32),
          DepositorAccountClass = FitNullable(transaction.AccountClass, 32),
          TransactionReferenceNo = Fit(transaction.TransactionReferenceNo, 80),
          DepositBranchCode = Fit(transaction.DepositBranchCode, 32),
          DepositBranchName = FitNullable(transaction.DepositBranchName, 220),
          TransactionCurrency = Fit(string.IsNullOrWhiteSpace(transaction.Currency) ? "ETB" : transaction.Currency, 8),
          TransactionValueDate = transaction.ValueDate.ToUniversalTime(),
          Status = ResourceMobilizationStatuses.PendingCheckerApproval,
          MakerUserName = FitNullable(currentUser.Username, 150),
          MakerBranchCode = FitNullable(currentUser.BranchCode, 32),
          MakerBranchName = FitNullable(currentUser.BranchName, 120),
          RequestPayload = JsonSerializer.Serialize(new
          {
            RegistrationBatchReference = registrationBatchReference,
            IsJointRegistration = isJointRegistration,
            JointParticipantCount = employees.Count,
            ShareAmount = splitAmounts[index],
            Employee = employee,
            Participants = employees.Select(x => new { x.Id, x.EmployeeReference, x.FullName }).ToList(),
            MonthlyTargetAmount = monthlyTargetAmount,
            DepositProductType = normalizedProductType,
            NewAccountCount = newAccountCount,
            request.TransactionReferenceNo,
            request.AccountNumber,
            DepositorCustomerName = customerName
          }),
          ResponsePayload = transaction.RawPayload
        });
      }

      dbContext.ResourceMobilizationRecords.AddRange(records);
      await dbContext.SaveChangesAsync(cancellationToken);

      await auditService.LogAsync(
        GetCurrentUserId(),
        null,
        "SUBMIT_RESOURCE_MOBILIZATION",
        "ResourceMobilizationRecord",
        registrationBatchReference,
        new
        {
          RegistrationBatchReference = registrationBatchReference,
          IsJointRegistration = isJointRegistration,
          JointParticipantCount = employees.Count,
          TransactionReferenceNo = transactionReferenceNo,
          TotalDepositMobilized = transaction.Amount,
          DepositProductType = normalizedProductType
        },
        HttpContext.Connection.RemoteIpAddress?.ToString(),
        cancellationToken
      );

      var primaryRecord = records.OrderBy(x => x.JointSequenceNumber).First();
      return CreatedAtAction(nameof(Get), new { id = primaryRecord.Id }, Map(primaryRecord));
    }
    catch (DbUpdateException ex)
    {
      var details = ex.InnerException?.Message ?? ex.Message;
      logger.LogError(ex, "Resource mobilization submission failed. EmployeeDirectoryEntryId={EmployeeDirectoryEntryId}, TransactionReferenceNo={TransactionReferenceNo}, AccountNumber={AccountNumber}",
        request.EmployeeDirectoryEntryId, request.TransactionReferenceNo, request.AccountNumber);
      return StatusCode(500, new
      {
        message = $"Unable to save the resource mobilization record. {details}"
      });
    }
    catch (Exception ex)
    {
      logger.LogError(ex, "Resource mobilization submission failed. EmployeeDirectoryEntryId={EmployeeDirectoryEntryId}, TransactionReferenceNo={TransactionReferenceNo}, AccountNumber={AccountNumber}",
        request.EmployeeDirectoryEntryId, request.TransactionReferenceNo, request.AccountNumber);
      return StatusCode(500, new
      {
        message = $"Unable to save the resource mobilization record. {ex.Message}"
      });
    }
  }

  [HttpGet("mine")]
  [Authorize(Roles = UserRoles.Maker)]
  public async Task<ActionResult<IReadOnlyList<ResourceMobilizationRecordDto>>> Mine(CancellationToken cancellationToken)
  {
    var currentUser = await GetCurrentUserAsync(cancellationToken);
    var items = await dbContext.ResourceMobilizationRecords
      .AsNoTracking()
      .Where(x => x.MakerUserName == currentUser.Username)
      .OrderByDescending(x => x.CreatedAt)
      .ToListAsync(cancellationToken);

    return Ok(items.Select(Map).ToList());
  }

  [HttpGet("pending")]
  [Authorize(Roles = UserRoles.Checker)]
  public async Task<ActionResult<IReadOnlyList<ResourceMobilizationRecordDto>>> Pending(CancellationToken cancellationToken)
  {
    var currentUser = await GetCurrentUserAsync(cancellationToken);
    var items = await dbContext.ResourceMobilizationRecords
      .AsNoTracking()
      .Where(x =>
        x.Status == ResourceMobilizationStatuses.PendingCheckerApproval &&
        x.MakerBranchCode == currentUser.BranchCode)
      .OrderByDescending(x => x.CreatedAt)
      .ToListAsync(cancellationToken);

    return Ok(items.Select(Map).ToList());
  }

  [HttpGet("completed")]
  [Authorize(Roles = $"{UserRoles.Admin},{UserRoles.SystemAdmin},{UserRoles.SeniorManagement},{UserRoles.BranchBanking},{UserRoles.Maker},{UserRoles.Checker},{UserRoles.ReportViewer}")]
  public async Task<ActionResult<IReadOnlyList<ResourceMobilizationRecordDto>>> Completed(CancellationToken cancellationToken)
  {
    var currentUser = await GetCurrentUserAsync(cancellationToken);
    var query = dbContext.ResourceMobilizationRecords
      .AsNoTracking()
      .Where(x => x.Status != ResourceMobilizationStatuses.PendingCheckerApproval);

    if (!HasGlobalReportAccess(currentUser))
    {
      query = query.Where(x => x.MakerBranchCode == currentUser.BranchCode);
    }

    var items = await query
      .OrderByDescending(x => x.ApprovedAt ?? x.RejectedAt ?? x.UpdatedAt)
      .ToListAsync(cancellationToken);

    return Ok(items.Select(Map).ToList());
  }

  [HttpGet("report")]
  [Authorize(Roles = $"{UserRoles.Admin},{UserRoles.SystemAdmin},{UserRoles.SeniorManagement},{UserRoles.BranchBanking},{UserRoles.Maker},{UserRoles.Checker},{UserRoles.ReportViewer}")]
  public async Task<ActionResult<ResourceMobilizationReportResponseDto>> Report(
    [FromQuery] ResourceMobilizationReportQueryDto queryDto,
    CancellationToken cancellationToken)
  {
    var currentUser = await GetCurrentUserAsync(cancellationToken);
    var query = dbContext.ResourceMobilizationRecords.AsNoTracking();

    if (!HasGlobalReportAccess(currentUser))
    {
      query = query.Where(x => x.MakerBranchCode == currentUser.BranchCode);
    }

    if (!string.IsNullOrWhiteSpace(queryDto.Status))
    {
      var status = queryDto.Status.Trim().ToUpperInvariant();
      query = query.Where(x => (x.Status ?? string.Empty).ToUpper() == status);
    }

    if (!string.IsNullOrWhiteSpace(queryDto.DepositProductType))
    {
      var productType = queryDto.DepositProductType.Trim().ToUpperInvariant();
      query = query.Where(x => (x.DepositProductType ?? string.Empty).ToUpper() == productType);
    }

    if (queryDto.FromDate.HasValue)
    {
      var fromDate = queryDto.FromDate.Value;
      query = query.Where(x => x.TransactionValueDate >= fromDate);
    }

    if (queryDto.ToDate.HasValue)
    {
      var toDate = queryDto.ToDate.Value;
      query = query.Where(x => x.TransactionValueDate <= toDate);
    }

    if (!string.IsNullOrWhiteSpace(queryDto.Search))
    {
      var keyword = $"%{queryDto.Search.Trim()}%";
      query = query.Where(x =>
        EF.Functions.ILike(x.RegistrationReference, keyword) ||
        EF.Functions.ILike(x.RegistrationBatchReference, keyword) ||
        EF.Functions.ILike(x.EmployeeReference, keyword) ||
        EF.Functions.ILike(x.EmployeeFullName, keyword) ||
        EF.Functions.ILike(x.EmployeeBranchCode ?? string.Empty, keyword) ||
        EF.Functions.ILike(x.EmployeeBranchName ?? string.Empty, keyword) ||
        EF.Functions.ILike(x.EmployeeDepartmentName ?? string.Empty, keyword) ||
        EF.Functions.ILike(x.DepositorCustomerName, keyword) ||
        EF.Functions.ILike(x.DepositorAccountNumber, keyword) ||
        EF.Functions.ILike(x.DepositorCustomerNumber ?? string.Empty, keyword) ||
        EF.Functions.ILike(x.TransactionReferenceNo, keyword) ||
        EF.Functions.ILike(x.DepositBranchCode, keyword) ||
        EF.Functions.ILike(x.DepositBranchName ?? string.Empty, keyword) ||
        EF.Functions.ILike(x.MakerUserName ?? string.Empty, keyword) ||
        EF.Functions.ILike(x.CheckerUserName ?? string.Empty, keyword));
    }

    var sortBy = (queryDto.SortBy ?? "transactionValueDate").Trim().ToLowerInvariant();
    var sortDirection = (queryDto.SortDirection ?? "desc").Trim().ToLowerInvariant();
    var sortAscending = sortDirection == "asc";
    query = sortBy switch
    {
      "employeefullname" => sortAscending ? query.OrderBy(x => x.EmployeeFullName) : query.OrderByDescending(x => x.EmployeeFullName),
      "depositorcustomername" => sortAscending ? query.OrderBy(x => x.DepositorCustomerName) : query.OrderByDescending(x => x.DepositorCustomerName),
      "totaldepositmobilized" => sortAscending ? query.OrderBy(x => x.TotalDepositMobilized) : query.OrderByDescending(x => x.TotalDepositMobilized),
      "status" => sortAscending ? query.OrderBy(x => x.Status) : query.OrderByDescending(x => x.Status),
      "transactionreferenceno" => sortAscending ? query.OrderBy(x => x.TransactionReferenceNo) : query.OrderByDescending(x => x.TransactionReferenceNo),
      "createdat" => sortAscending ? query.OrderBy(x => x.CreatedAt) : query.OrderByDescending(x => x.CreatedAt),
      _ => sortAscending ? query.OrderBy(x => x.TransactionValueDate) : query.OrderByDescending(x => x.TransactionValueDate)
    };

    var totalRecords = await query.CountAsync(cancellationToken);
    var pageSize = queryDto.PageSize == -1 ? int.MaxValue : (queryDto.PageSize <= 0 ? 20 : queryDto.PageSize);
    var page = queryDto.Page <= 0 ? 1 : queryDto.Page;

    List<ResourceMobilizationRecord> items;
    var totalPages = 1;

    if (pageSize == int.MaxValue)
    {
      items = await query.ToListAsync(cancellationToken);
      page = 1;
    }
    else
    {
      totalPages = Math.Max(1, (int)Math.Ceiling(totalRecords / (double)pageSize));
      page = Math.Min(page, totalPages);
      var skip = (page - 1) * pageSize;
      items = await query.Skip(skip).Take(pageSize).ToListAsync(cancellationToken);
    }

    return Ok(new ResourceMobilizationReportResponseDto(
      page,
      pageSize,
      totalRecords,
      totalPages,
      items.Select(Map).ToList()
    ));
  }

  [HttpGet("dashboard-stats")]
  [Authorize(Roles = $"{UserRoles.Admin},{UserRoles.SystemAdmin},{UserRoles.SeniorManagement},{UserRoles.BranchBanking},{UserRoles.Maker},{UserRoles.Checker},{UserRoles.ReportViewer}")]
  public async Task<ActionResult<ResourceMobilizationDashboardStatsDto>> DashboardStats(CancellationToken cancellationToken)
  {
    var currentUser = await GetCurrentUserAsync(cancellationToken);
    var query = dbContext.ResourceMobilizationRecords.AsNoTracking();

    if (!HasGlobalReportAccess(currentUser))
    {
      query = query.Where(x => x.MakerBranchCode == currentUser.BranchCode);
    }

    var records = await query.ToListAsync(cancellationToken);
    var todayRange = ResolveTodayRangeUtc();
    var weekRange = ResolveCurrentWeekRangeUtc();
    var monthRange = ResolveCurrentMonthRangeUtc();

    return Ok(new ResourceMobilizationDashboardStatsDto(
      HasGlobalReportAccess(currentUser) ? "ALL_BRANCHES" : "BRANCH_ONLY",
      HasGlobalReportAccess(currentUser) ? null : currentUser.BranchCode,
      BuildPeriod(todayRange.StartUtc, todayRange.EndUtc, records),
      BuildPeriod(weekRange.StartUtc, weekRange.EndUtc, records),
      BuildPeriod(monthRange.StartUtc, monthRange.EndUtc, records)
    ));
  }

  [HttpGet("{id:int}")]
  [Authorize(Roles = $"{UserRoles.Admin},{UserRoles.SystemAdmin},{UserRoles.SeniorManagement},{UserRoles.BranchBanking},{UserRoles.Maker},{UserRoles.Checker},{UserRoles.ReportViewer}")]
  public async Task<ActionResult<ResourceMobilizationRecordDto>> Get(int id, CancellationToken cancellationToken)
  {
    var currentUser = await GetCurrentUserAsync(cancellationToken);
    var record = await dbContext.ResourceMobilizationRecords.FirstOrDefaultAsync(x => x.Id == id, cancellationToken);
    if (record is null)
    {
      return NotFound(new { message = "Resource mobilization record was not found." });
    }

    if (!CanAccessRecord(currentUser, record))
    {
      return Forbid();
    }

    return Ok(Map(record));
  }

  [HttpPost("{id:int}/approve")]
  [Authorize(Roles = UserRoles.Checker)]
  public async Task<ActionResult<ResourceMobilizationRecordDto>> Approve(int id, [FromBody] ApproveResourceMobilizationRequest request, CancellationToken cancellationToken)
  {
    var currentUser = await GetCurrentUserAsync(cancellationToken);
    var record = await dbContext.ResourceMobilizationRecords.FirstOrDefaultAsync(x => x.Id == id, cancellationToken);
    if (record is null)
    {
      return NotFound(new { message = "Resource mobilization record was not found." });
    }

    if (!CanCheckerAccess(currentUser, record))
    {
      return Forbid();
    }

    var batchReference = string.IsNullOrWhiteSpace(record.RegistrationBatchReference)
      ? record.RegistrationReference
      : record.RegistrationBatchReference;

    var batchRecords = await dbContext.ResourceMobilizationRecords
      .Where(x => x.RegistrationBatchReference == batchReference)
      .OrderBy(x => x.JointSequenceNumber)
      .ThenBy(x => x.Id)
      .ToListAsync(cancellationToken);

    if (batchRecords.Count == 0)
    {
      batchRecords = [record];
    }

    if (batchRecords.Any(x => !string.Equals(x.Status, ResourceMobilizationStatuses.PendingCheckerApproval, StringComparison.OrdinalIgnoreCase)))
    {
      return BadRequest(new { message = "Only pending requests can be approved." });
    }

    var approvedAt = DateTimeOffset.UtcNow;
    foreach (var item in batchRecords)
    {
      item.Status = ResourceMobilizationStatuses.Approved;
      item.CheckerUserName = currentUser.Username;
      item.CheckerBranchCode = currentUser.BranchCode;
      item.CheckerBranchName = currentUser.BranchName;
      item.CheckerComment = string.IsNullOrWhiteSpace(request.CheckerComment) ? null : request.CheckerComment.Trim();
      item.RejectionReason = null;
      item.ApprovedAt = approvedAt;
      item.RejectedAt = null;
      item.UpdatedAt = approvedAt;
    }

    await dbContext.SaveChangesAsync(cancellationToken);

    await auditService.LogAsync(
      GetCurrentUserId(),
      null,
      "APPROVE_RESOURCE_MOBILIZATION",
      "ResourceMobilizationRecord",
      batchReference,
      new
      {
        RegistrationBatchReference = batchReference,
        TransactionReferenceNo = record.TransactionReferenceNo,
        ParticipantCount = batchRecords.Count,
        TotalDepositMobilized = batchRecords.Sum(x => x.TotalDepositMobilized)
      },
      HttpContext.Connection.RemoteIpAddress?.ToString(),
      cancellationToken
    );

    return Ok(Map(batchRecords.First()));
  }

  [HttpPost("{id:int}/reject")]
  [Authorize(Roles = UserRoles.Checker)]
  public async Task<ActionResult<ResourceMobilizationRecordDto>> Reject(int id, [FromBody] RejectResourceMobilizationRequest request, CancellationToken cancellationToken)
  {
    var currentUser = await GetCurrentUserAsync(cancellationToken);
    var record = await dbContext.ResourceMobilizationRecords.FirstOrDefaultAsync(x => x.Id == id, cancellationToken);
    if (record is null)
    {
      return NotFound(new { message = "Resource mobilization record was not found." });
    }

    if (!CanCheckerAccess(currentUser, record))
    {
      return Forbid();
    }

    var batchReference = string.IsNullOrWhiteSpace(record.RegistrationBatchReference)
      ? record.RegistrationReference
      : record.RegistrationBatchReference;

    var batchRecords = await dbContext.ResourceMobilizationRecords
      .Where(x => x.RegistrationBatchReference == batchReference)
      .OrderBy(x => x.JointSequenceNumber)
      .ThenBy(x => x.Id)
      .ToListAsync(cancellationToken);

    if (batchRecords.Count == 0)
    {
      batchRecords = [record];
    }

    if (batchRecords.Any(x => !string.Equals(x.Status, ResourceMobilizationStatuses.PendingCheckerApproval, StringComparison.OrdinalIgnoreCase)))
    {
      return BadRequest(new { message = "Only pending requests can be rejected." });
    }

    var rejectionReason = (request.RejectionReason ?? string.Empty).Trim();
    if (string.IsNullOrWhiteSpace(rejectionReason))
    {
      return BadRequest(new { message = "Enter a rejection reason." });
    }

    var rejectedAt = DateTimeOffset.UtcNow;
    foreach (var item in batchRecords)
    {
      item.Status = ResourceMobilizationStatuses.Rejected;
      item.CheckerUserName = currentUser.Username;
      item.CheckerBranchCode = currentUser.BranchCode;
      item.CheckerBranchName = currentUser.BranchName;
      item.CheckerComment = rejectionReason;
      item.RejectionReason = rejectionReason;
      item.RejectedAt = rejectedAt;
      item.ApprovedAt = null;
      item.UpdatedAt = rejectedAt;
    }

    await dbContext.SaveChangesAsync(cancellationToken);

    await auditService.LogAsync(
      GetCurrentUserId(),
      null,
      "REJECT_RESOURCE_MOBILIZATION",
      "ResourceMobilizationRecord",
      batchReference,
      new
      {
        RegistrationBatchReference = batchReference,
        TransactionReferenceNo = record.TransactionReferenceNo,
        ParticipantCount = batchRecords.Count,
        RejectionReason = rejectionReason
      },
      HttpContext.Connection.RemoteIpAddress?.ToString(),
      cancellationToken
    );

    return Ok(Map(batchRecords.First()));
  }

  [HttpDelete("{id:int}")]
  [Authorize(Roles = UserRoles.SystemAdmin)]
  public async Task<IActionResult> Delete(int id, CancellationToken cancellationToken)
  {
    var record = await dbContext.ResourceMobilizationRecords.FirstOrDefaultAsync(x => x.Id == id, cancellationToken);
    if (record is null)
    {
      return NotFound(new { message = "Resource mobilization record was not found." });
    }

    var batchReference = string.IsNullOrWhiteSpace(record.RegistrationBatchReference)
      ? record.RegistrationReference
      : record.RegistrationBatchReference;

    var batchRecords = await dbContext.ResourceMobilizationRecords
      .Where(x => x.RegistrationBatchReference == batchReference)
      .ToListAsync(cancellationToken);

    if (batchRecords.Count == 0)
    {
      batchRecords = [record];
    }

    dbContext.ResourceMobilizationRecords.RemoveRange(batchRecords);
    await dbContext.SaveChangesAsync(cancellationToken);

    await auditService.LogAsync(
      GetCurrentUserId(),
      null,
      "DELETE_RESOURCE_MOBILIZATION",
      "ResourceMobilizationRecord",
      batchReference,
      new
      {
        RegistrationBatchReference = batchReference,
        TransactionReferenceNo = record.TransactionReferenceNo,
        ParticipantCount = batchRecords.Count,
        record.Status
      },
      HttpContext.Connection.RemoteIpAddress?.ToString(),
      cancellationToken
    );

    return NoContent();
  }

  private async Task<AppUser> GetCurrentUserAsync(CancellationToken cancellationToken)
  {
    var userId = Guid.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!);
    return await dbContext.Users.FirstAsync(x => x.Id == userId, cancellationToken);
  }

  private Guid? GetCurrentUserId()
  {
    var rawUserId = User.FindFirstValue(ClaimTypes.NameIdentifier);
    return Guid.TryParse(rawUserId, out var userId) ? userId : null;
  }

  private static bool HasGlobalReportAccess(AppUser user)
  {
    return string.Equals(user.Role, UserRoles.Admin, StringComparison.OrdinalIgnoreCase) ||
           string.Equals(user.Role, UserRoles.SystemAdmin, StringComparison.OrdinalIgnoreCase) ||
           string.Equals(user.Role, UserRoles.SeniorManagement, StringComparison.OrdinalIgnoreCase) ||
           string.Equals(user.Role, UserRoles.BranchBanking, StringComparison.OrdinalIgnoreCase) ||
           IsHeadOfficeBranch(user.BranchCode);
  }

  private static bool CanCheckerAccess(AppUser user, ResourceMobilizationRecord record)
  {
    return string.Equals(record.MakerBranchCode, user.BranchCode, StringComparison.OrdinalIgnoreCase);
  }

  private static bool CanAccessRecord(AppUser user, ResourceMobilizationRecord record)
  {
    if (HasGlobalReportAccess(user))
    {
      return true;
    }

    if (string.Equals(user.Role, UserRoles.Maker, StringComparison.OrdinalIgnoreCase))
    {
      return string.Equals(record.MakerUserName, user.Username, StringComparison.OrdinalIgnoreCase);
    }

    if (string.Equals(user.Role, UserRoles.Checker, StringComparison.OrdinalIgnoreCase))
    {
      return CanCheckerAccess(user, record);
    }

    return false;
  }

  private static string? NormalizeProductType(string? value)
  {
    var normalized = (value ?? string.Empty).Trim().ToUpperInvariant();
    return AllowedProductTypes.Contains(normalized, StringComparer.OrdinalIgnoreCase)
      ? normalized
      : null;
  }

  private static string BuildRegistrationBatchReference()
  {
    var random = Random.Shared.Next(0, 10_000);
    return $"RM{DateTime.UtcNow:yyMMddHHmmss}{random:D4}";
  }

  private static string BuildRegistrationReference(string batchReference, int sequenceNumber, int totalCount)
  {
    if (totalCount <= 1)
    {
      return batchReference;
    }

    var suffix = $"-{sequenceNumber:D2}";
    var prefixLength = Math.Min(batchReference.Length, 40 - suffix.Length);
    return $"{batchReference[..prefixLength]}{suffix}";
  }

  private static string Fit(string? value, int maxLength)
  {
    var normalized = (value ?? string.Empty).Trim();
    return normalized.Length <= maxLength ? normalized : normalized[..maxLength];
  }

  private static string? FitNullable(string? value, int maxLength)
  {
    var normalized = (value ?? string.Empty).Trim();
    if (string.IsNullOrWhiteSpace(normalized))
    {
      return null;
    }

    return normalized.Length <= maxLength ? normalized : normalized[..maxLength];
  }

  private static ResourceMobilizationRecordDto Map(ResourceMobilizationRecord record)
  {
    return new ResourceMobilizationRecordDto(
      record.Id,
      record.RegistrationReference,
      string.IsNullOrWhiteSpace(record.RegistrationBatchReference) ? record.RegistrationReference : record.RegistrationBatchReference,
      record.IsJointRegistration,
      record.JointParticipantCount <= 0 ? 1 : record.JointParticipantCount,
      record.JointSequenceNumber <= 0 ? 1 : record.JointSequenceNumber,
      record.EmployeeReference,
      record.EmployeeFullName,
      record.EmployeePhoneNumber,
      record.EmployeeBranchCode,
      record.EmployeeBranchName,
      record.EmployeeDepartmentName,
      record.EmployeePositionName,
      record.EmployeeClassification,
      record.MonthlyTargetAmount,
      record.DepositProductType,
      record.SourceTransactionAmount > 0 ? record.SourceTransactionAmount : record.TotalDepositMobilized,
      record.TotalDepositMobilized,
      record.NewAccountCount,
      record.DepositorCustomerName,
      record.DepositorCustomerNumber,
      record.DepositorAccountNumber,
      record.DepositorAccountClass,
      record.TransactionReferenceNo,
      record.DepositBranchCode,
      record.DepositBranchName,
      record.TransactionCurrency,
      record.TransactionValueDate,
      record.Status,
      record.MakerUserName,
      record.MakerBranchCode,
      record.MakerBranchName,
      record.CheckerUserName,
      record.CheckerBranchCode,
      record.CheckerBranchName,
      record.CheckerComment,
      record.RejectionReason,
      record.CreatedAt,
      record.UpdatedAt,
      record.ApprovedAt,
      record.RejectedAt
    );
  }

  private static ResourceMobilizationDashboardPeriodDto BuildPeriod(
    DateTimeOffset startUtc,
    DateTimeOffset endUtc,
    IReadOnlyCollection<ResourceMobilizationRecord> allRecords)
  {
    var rangeRecords = allRecords
      .Where(x => x.TransactionValueDate >= startUtc && x.TransactionValueDate < endUtc)
      .ToList();

    var approvedRows = rangeRecords
      .Where(x => string.Equals(x.Status, ResourceMobilizationStatuses.Approved, StringComparison.OrdinalIgnoreCase))
      .ToList();

    var topMobilizers = approvedRows
      .GroupBy(x => new
      {
        x.EmployeeReference,
        x.EmployeeFullName,
        x.EmployeeDepartmentName,
        x.EmployeeBranchCode,
        x.EmployeeBranchName
      })
      .Select(group => new ResourceMobilizationLeaderboardItemDto(
        group.Key.EmployeeReference,
        group.Key.EmployeeFullName,
        group.Key.EmployeeDepartmentName,
        group.Key.EmployeeBranchCode,
        group.Key.EmployeeBranchName,
        group.Sum(x => x.TotalDepositMobilized),
        group.Count(),
        group.Sum(x => x.NewAccountCount)
      ))
      .OrderByDescending(x => x.TotalAmount)
      .ThenBy(x => x.EmployeeFullName)
      .Take(10)
      .ToList();

    return new ResourceMobilizationDashboardPeriodDto(
      startUtc,
      endUtc,
      BuildStatusBreakdown(rangeRecords),
      topMobilizers
    );
  }

  private static ResourceMobilizationStatusBreakdownDto BuildStatusBreakdown(IReadOnlyCollection<ResourceMobilizationRecord> records)
  {
    var approvedRows = records
      .Where(x => string.Equals(x.Status, ResourceMobilizationStatuses.Approved, StringComparison.OrdinalIgnoreCase))
      .ToList();

    var totalRequests = CountDistinctRequests(records);
    var pendingRequests = CountDistinctRequests(records.Where(x => string.Equals(x.Status, ResourceMobilizationStatuses.PendingCheckerApproval, StringComparison.OrdinalIgnoreCase)));
    var approvedRequests = CountDistinctRequests(approvedRows);
    var rejectedRequests = CountDistinctRequests(records.Where(x => string.Equals(x.Status, ResourceMobilizationStatuses.Rejected, StringComparison.OrdinalIgnoreCase)));

    return new ResourceMobilizationStatusBreakdownDto(
      totalRequests,
      pendingRequests,
      approvedRequests,
      rejectedRequests,
      approvedRows.Sum(x => x.TotalDepositMobilized),
      approvedRows
        .Select(x => x.EmployeeReference)
        .Where(x => !string.IsNullOrWhiteSpace(x))
        .Distinct(StringComparer.OrdinalIgnoreCase)
        .Count()
    );
  }

  private static (DateTimeOffset StartUtc, DateTimeOffset EndUtc) ResolveTodayRangeUtc()
  {
    var timeZone = ResolveEastAfricaTimeZone();
    var localNow = TimeZoneInfo.ConvertTime(DateTimeOffset.UtcNow, timeZone);
    var startLocal = new DateTimeOffset(localNow.Year, localNow.Month, localNow.Day, 0, 0, 0, localNow.Offset);
    return (startLocal.ToUniversalTime(), startLocal.AddDays(1).ToUniversalTime());
  }

  private static (DateTimeOffset StartUtc, DateTimeOffset EndUtc) ResolveCurrentWeekRangeUtc()
  {
    var timeZone = ResolveEastAfricaTimeZone();
    var localNow = TimeZoneInfo.ConvertTime(DateTimeOffset.UtcNow, timeZone);
    var startOfWeek = localNow.Date.AddDays(-(((int)localNow.DayOfWeek + 6) % 7));
    var startLocal = new DateTimeOffset(startOfWeek.Year, startOfWeek.Month, startOfWeek.Day, 0, 0, 0, localNow.Offset);
    return (startLocal.ToUniversalTime(), startLocal.AddDays(7).ToUniversalTime());
  }

  private static (DateTimeOffset StartUtc, DateTimeOffset EndUtc) ResolveCurrentMonthRangeUtc()
  {
    var timeZone = ResolveEastAfricaTimeZone();
    var localNow = TimeZoneInfo.ConvertTime(DateTimeOffset.UtcNow, timeZone);
    var startLocal = new DateTimeOffset(localNow.Year, localNow.Month, 1, 0, 0, 0, localNow.Offset);
    return (startLocal.ToUniversalTime(), startLocal.AddMonths(1).ToUniversalTime());
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

  private static int CountDistinctRequests(IEnumerable<ResourceMobilizationRecord> records)
  {
    return records
      .Select(x => string.IsNullOrWhiteSpace(x.RegistrationBatchReference) ? x.RegistrationReference : x.RegistrationBatchReference)
      .Where(x => !string.IsNullOrWhiteSpace(x))
      .Distinct(StringComparer.OrdinalIgnoreCase)
      .Count();
  }

  private static bool IsHeadOfficeBranch(string? branchCode)
  {
    var normalized = (branchCode ?? string.Empty).Trim();
    return string.Equals(normalized, "000", StringComparison.OrdinalIgnoreCase) ||
           string.Equals(normalized, "001", StringComparison.OrdinalIgnoreCase);
  }

  private static IReadOnlyList<decimal> SplitAmountEvenly(decimal amount, int participantCount)
  {
    if (participantCount <= 1)
    {
      return [decimal.Round(amount, 2, MidpointRounding.AwayFromZero)];
    }

    var totalCents = decimal.ToInt64(decimal.Round(amount * 100m, 0, MidpointRounding.AwayFromZero));
    var baseCents = totalCents / participantCount;
    var remainder = totalCents % participantCount;
    var values = new List<decimal>(participantCount);

    for (var index = 0; index < participantCount; index += 1)
    {
      var shareCents = baseCents + (index < remainder ? 1 : 0);
      values.Add(shareCents / 100m);
    }

    return values;
  }
}
