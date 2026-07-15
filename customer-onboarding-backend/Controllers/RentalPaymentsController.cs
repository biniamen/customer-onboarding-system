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
[Route("api/core/rental-payments")]
[Authorize]
public class RentalPaymentsController(
  AppDbContext dbContext,
  IRentalPaymentService rentalPaymentService,
  IAuditService auditService,
  IOptions<RentalPaymentOptions> rentalOptions
) : ControllerBase
{
  private readonly RentalPaymentOptions _rentalOptions = rentalOptions.Value;

  [HttpPost("inquiry")]
  [Authorize(Roles = UserRoles.RentalMaker)]
  public async Task<ActionResult<RentalPaymentInquiryDto>> Inquiry([FromBody] RentalPaymentInquiryRequest request, CancellationToken cancellationToken)
  {
    var currentUser = await GetCurrentUserAsync(cancellationToken);
    var billId = (request.BillId ?? string.Empty).Trim();
    var balerId = (request.BalerId ?? string.Empty).Trim();

    if (string.IsNullOrWhiteSpace(billId) || string.IsNullOrWhiteSpace(balerId))
    {
      return BadRequest(new { message = "Bill ID and baler ID are required." });
    }

    var inquiryResult = await rentalPaymentService.InquireAsync(billId, balerId, cancellationToken);
    string? manifestId = null;

    if (inquiryResult.Success)
    {
      var activeStatuses = new[]
      {
        RentalPaymentStatuses.Unpaid,
        RentalPaymentStatuses.PendingCheckerApproval,
        RentalPaymentStatuses.Processing,
        RentalPaymentStatuses.CbsPostedCallbackPending,
        RentalPaymentStatuses.CbsConfirmationRequired
      };

      var record = await dbContext.RentalPaymentRequests
        .OrderByDescending(x => x.CreatedAt)
        .FirstOrDefaultAsync(x =>
          x.BillId == inquiryResult.BillId &&
          x.BalerId == inquiryResult.BalerId &&
          x.MakerUserName == currentUser.Username &&
          activeStatuses.Contains(x.Status),
          cancellationToken);

      if (record is null)
      {
        record = new RentalPaymentRequest
        {
          ManifestId = BuildManifestId(),
          BillId = inquiryResult.BillId,
          BalerId = inquiryResult.BalerId,
          MakerUserName = currentUser.Username,
          MakerBranchCode = currentUser.BranchCode,
          CreatedAt = DateTimeOffset.UtcNow
        };
        dbContext.RentalPaymentRequests.Add(record);
      }

      record.CustomerId = inquiryResult.CustomerId;
      record.CustomerName = inquiryResult.CustomerName;
      record.TenantName = inquiryResult.TenantName;
      record.OwnerName = inquiryResult.OwnerName;
      record.OwnerAccountNumber = inquiryResult.OwnerAccountNumber;
      record.PropertyName = inquiryResult.PropertyName;
      record.BillDescription = inquiryResult.BillDescription;
      record.Reason = inquiryResult.Reason;
      record.AmountDue = inquiryResult.AmountDue;
      record.BaseAmount = inquiryResult.BaseAmount;
      record.PenaltyAmount = inquiryResult.PenaltyAmount;
      record.DueDate = inquiryResult.DueDate;

      if (!string.Equals(record.Status, RentalPaymentStatuses.PendingCheckerApproval, StringComparison.OrdinalIgnoreCase) &&
          !string.Equals(record.Status, RentalPaymentStatuses.Processing, StringComparison.OrdinalIgnoreCase))
      {
        record.Status = RentalPaymentStatuses.Unpaid;
        record.StatusMessage = inquiryResult.Message;
      }

      record.UpdatedAt = DateTimeOffset.UtcNow;
      record.RequestPayload = JsonSerializer.Serialize(new { billId, balerId });
      record.ResponsePayload = inquiryResult.RawResponse;

      await dbContext.SaveChangesAsync(cancellationToken);
      manifestId = record.ManifestId;

      await auditService.LogAsync(
        Guid.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!),
        null,
        "RENTAL_PAYMENT_INQUIRY",
        "RentalPaymentRequest",
        record.Id.ToString(),
        new { record.ManifestId, record.BillId, record.BalerId, record.AmountDue },
        HttpContext.Connection.RemoteIpAddress?.ToString(),
        cancellationToken
      );
    }

    return Ok(new RentalPaymentInquiryDto(
      inquiryResult.Success,
      inquiryResult.Message,
      manifestId,
      inquiryResult.BillId,
      inquiryResult.BalerId,
      inquiryResult.CustomerId,
      inquiryResult.CustomerName,
      inquiryResult.TenantName,
      inquiryResult.OwnerName,
      inquiryResult.OwnerAccountNumber,
      inquiryResult.PropertyName,
      inquiryResult.BillDescription,
      inquiryResult.Reason,
      inquiryResult.AmountDue,
      inquiryResult.BaseAmount,
      inquiryResult.PenaltyAmount,
      inquiryResult.CurrentPeriod,
      inquiryResult.PenaltyType,
      inquiryResult.IsOverdue,
      _rentalOptions.CashDebitGlAccount,
      inquiryResult.DueDate?.ToString("yyyy-MM-dd"),
      inquiryResult.RawResponse
    ));
  }

  [HttpPost("submit")]
  [HttpPost("pay")]
  [Authorize(Roles = UserRoles.RentalMaker)]
  public async Task<ActionResult<RentalPaymentRecordDto>> Submit([FromBody] SubmitRentalPaymentRequest request, CancellationToken cancellationToken)
  {
    var currentUser = await GetCurrentUserAsync(cancellationToken);
    var manifestId = (request.ManifestId ?? string.Empty).Trim();
    var billId = (request.BillId ?? string.Empty).Trim();
    var paymentMode = NormalizePaymentMode(request.PaymentMode);
    var debitAccount = (request.DebitAccount ?? string.Empty).Trim();

    if (string.IsNullOrWhiteSpace(manifestId) || string.IsNullOrWhiteSpace(billId))
    {
      return BadRequest(new { message = "Manifest ID and bill ID are required." });
    }

    if (request.Amount <= 0)
    {
      return BadRequest(new { message = "Payment amount must be greater than zero." });
    }

    if (paymentMode == "ACCOUNT" && debitAccount.Length != 13)
    {
      return BadRequest(new { message = "Please provide a valid 13-digit debit account number." });
    }

    var record = await dbContext.RentalPaymentRequests
      .FirstOrDefaultAsync(x => x.ManifestId == manifestId && x.BillId == billId, cancellationToken);

    if (record is null)
    {
      return NotFound(new { message = "Rental payment session was not found. Please fetch the pending bill again." });
    }

    if (!string.Equals(record.MakerUserName, currentUser.Username, StringComparison.OrdinalIgnoreCase))
    {
      return Forbid();
    }

    if (string.Equals(record.Status, RentalPaymentStatuses.Approved, StringComparison.OrdinalIgnoreCase) ||
        string.Equals(record.Status, RentalPaymentStatuses.Paid, StringComparison.OrdinalIgnoreCase))
    {
      return Ok(Map(record));
    }

    if (string.Equals(record.Status, RentalPaymentStatuses.PendingCheckerApproval, StringComparison.OrdinalIgnoreCase))
    {
      return Conflict(new { message = "This rental payment request is already waiting for checker approval." });
    }

    if (string.Equals(record.Status, RentalPaymentStatuses.Processing, StringComparison.OrdinalIgnoreCase))
    {
      return Conflict(new { message = "This rental payment request is already being processed by the checker." });
    }

    if (record.AmountDue != request.Amount)
    {
      return BadRequest(new
      {
        message = "Entered amount does not match the rental amount due.",
        expectedAmount = record.AmountDue,
        enteredAmount = request.Amount
      });
    }

    record.Status = RentalPaymentStatuses.PendingCheckerApproval;
    record.StatusMessage = "Rental payment request submitted and waiting for checker approval.";
    record.DebitAccount = paymentMode == "CASH" ? _rentalOptions.CashDebitGlAccount : debitAccount;
    record.PaymentMode = paymentMode;
    record.PaidAtLocation = string.IsNullOrWhiteSpace(request.PaidAt) ? "Branch Portal" : request.PaidAt.Trim();
    record.TellerId = string.IsNullOrWhiteSpace(request.TellerId) ? null : request.TellerId.Trim();
    record.CheckerUserName = null;
    record.CheckerBranchCode = null;
    record.CheckerComment = null;
    record.RejectionReason = null;
    record.ApprovedAt = null;
    record.RejectedAt = null;
    record.CbsReference = null;
    record.ConfirmationCode = null;
    record.PaidAmount = null;
    record.PaidAt = null;
    record.UpdatedAt = DateTimeOffset.UtcNow;
    record.RequestPayload = JsonSerializer.Serialize(new
    {
      request.ManifestId,
      request.BillId,
      request.Amount,
      PaymentMode = paymentMode,
      DebitAccount = record.DebitAccount,
      record.PaidAtLocation,
      record.TellerId
    });

    await dbContext.SaveChangesAsync(cancellationToken);

    await auditService.LogAsync(
      Guid.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!),
      null,
      "RENTAL_PAYMENT_SUBMIT",
      "RentalPaymentRequest",
      record.Id.ToString(),
      new { record.ManifestId, record.BillId, record.Status, record.PaymentMode, record.DebitAccount, record.AmountDue },
      HttpContext.Connection.RemoteIpAddress?.ToString(),
      cancellationToken
    );

    return Ok(Map(record));
  }

  [HttpGet("mine")]
  [Authorize(Roles = UserRoles.RentalMaker)]
  public async Task<ActionResult<IEnumerable<RentalPaymentRecordDto>>> Mine(CancellationToken cancellationToken)
  {
    var currentUser = await GetCurrentUserAsync(cancellationToken);
    var records = await dbContext.RentalPaymentRequests
      .Where(x => x.MakerUserName == currentUser.Username)
      .OrderByDescending(x => x.UpdatedAt)
      .ToListAsync(cancellationToken);

    return Ok(records.Select(Map));
  }

  [HttpGet("status")]
  [Authorize(Roles = UserRoles.RentalMaker)]
  public async Task<ActionResult<RentalPaymentStatusDto>> Status([FromQuery] string manifestId, [FromQuery] string billId, CancellationToken cancellationToken)
  {
    var currentUser = await GetCurrentUserAsync(cancellationToken);
    var record = await dbContext.RentalPaymentRequests
      .FirstOrDefaultAsync(x => x.ManifestId == manifestId && x.BillId == billId, cancellationToken);

    if (record is null)
    {
      return NotFound(new { message = "Rental payment record was not found." });
    }

    if (!string.Equals(record.MakerUserName, currentUser.Username, StringComparison.OrdinalIgnoreCase))
    {
      return Forbid();
    }

    return Ok(new RentalPaymentStatusDto(
      record.ManifestId,
      record.BillId,
      record.Status,
      record.StatusMessage,
      record.CbsReference,
      record.ConfirmationCode,
      record.AmountDue,
      record.PaidAmount,
      record.PaidAt,
      record.UpdatedAt
    ));
  }

  [HttpGet("pending")]
  [Authorize(Roles = UserRoles.RentalChecker)]
  public async Task<ActionResult<IEnumerable<RentalPaymentRecordDto>>> Pending(CancellationToken cancellationToken)
  {
    var currentUser = await GetCurrentUserAsync(cancellationToken);
    var records = await dbContext.RentalPaymentRequests
      .Where(x =>
        x.Status == RentalPaymentStatuses.PendingCheckerApproval &&
        x.MakerBranchCode == currentUser.BranchCode)
      .OrderByDescending(x => x.UpdatedAt)
      .ToListAsync(cancellationToken);

    return Ok(records.Select(Map));
  }

  [HttpGet("completed")]
  [Authorize(Roles = UserRoles.RentalChecker)]
  public async Task<ActionResult<IEnumerable<RentalPaymentRecordDto>>> Completed(CancellationToken cancellationToken)
  {
    var currentUser = await GetCurrentUserAsync(cancellationToken);
    var records = await dbContext.RentalPaymentRequests
      .Where(x =>
        x.MakerBranchCode == currentUser.BranchCode &&
        x.Status != RentalPaymentStatuses.Unpaid &&
        x.Status != RentalPaymentStatuses.PendingCheckerApproval)
      .OrderByDescending(x => x.ApprovedAt ?? x.RejectedAt ?? x.UpdatedAt)
      .ToListAsync(cancellationToken);

    return Ok(records.Select(Map));
  }

  [HttpPost("{id:int}/approve")]
  [Authorize(Roles = UserRoles.RentalChecker)]
  public async Task<ActionResult<RentalPaymentRecordDto>> Approve(int id, [FromBody] ApproveRentalPaymentRequest request, CancellationToken cancellationToken)
  {
    var currentUser = await GetCurrentUserAsync(cancellationToken);
    var record = await dbContext.RentalPaymentRequests.FirstOrDefaultAsync(x => x.Id == id, cancellationToken);

    if (record is null)
    {
      return NotFound(new { message = "Rental payment request was not found." });
    }

    if (!CheckerCanAccess(record, currentUser))
    {
      return Forbid();
    }

    if (!string.Equals(record.Status, RentalPaymentStatuses.PendingCheckerApproval, StringComparison.OrdinalIgnoreCase))
    {
      return BadRequest(new { message = "Only pending rental payment requests can be approved." });
    }

    var checkerComment = request.CheckerComment?.Trim() ?? string.Empty;
    record.Status = RentalPaymentStatuses.Processing;
    record.StatusMessage = "Rental checker approved the request and CBS posting is in progress.";
    record.CheckerUserName = currentUser.Username;
    record.CheckerBranchCode = currentUser.BranchCode;
    record.CheckerComment = string.IsNullOrWhiteSpace(checkerComment) ? null : checkerComment;
    record.RejectionReason = null;
    record.UpdatedAt = DateTimeOffset.UtcNow;
    await dbContext.SaveChangesAsync(cancellationToken);

    var processingResult = await rentalPaymentService.ProcessPaymentAsync(
      record,
      NormalizePaymentMode(record.PaymentMode),
      string.Equals(record.PaymentMode, "CASH", StringComparison.OrdinalIgnoreCase) ? null : record.DebitAccount,
      currentUser.BranchCode,
      record.AmountDue,
      record.PaidAtLocation ?? "Branch Portal",
      record.TellerId,
      cancellationToken
    );

    record.Status = processingResult.Success
      ? RentalPaymentStatuses.Approved
      : processingResult.FinalStatus;
    record.StatusMessage = processingResult.Message;
    record.CbsReference = processingResult.CbsReference;
    record.ConfirmationCode = processingResult.ConfirmationCode;
    record.PaidAmount = processingResult.PaidAmount;
    record.PaidAt = processingResult.PaidAtUtc;
    record.RequestPayload = processingResult.RequestPayload;
    record.ResponsePayload = processingResult.ResponsePayload;
    record.ApprovedAt = DateTimeOffset.UtcNow;
    record.RejectedAt = null;
    record.UpdatedAt = DateTimeOffset.UtcNow;

    await dbContext.SaveChangesAsync(cancellationToken);

    await auditService.LogAsync(
      Guid.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!),
      null,
      "RENTAL_PAYMENT_APPROVE",
      "RentalPaymentRequest",
      record.Id.ToString(),
      new { record.ManifestId, record.BillId, record.Status, record.CbsReference, record.PaidAmount, record.CheckerUserName },
      HttpContext.Connection.RemoteIpAddress?.ToString(),
      cancellationToken
    );

    return Ok(Map(record));
  }

  [HttpPost("{id:int}/reject")]
  [Authorize(Roles = UserRoles.RentalChecker)]
  public async Task<ActionResult<RentalPaymentRecordDto>> Reject(int id, [FromBody] RejectRentalPaymentRequest request, CancellationToken cancellationToken)
  {
    var currentUser = await GetCurrentUserAsync(cancellationToken);
    var record = await dbContext.RentalPaymentRequests.FirstOrDefaultAsync(x => x.Id == id, cancellationToken);

    if (record is null)
    {
      return NotFound(new { message = "Rental payment request was not found." });
    }

    if (!CheckerCanAccess(record, currentUser))
    {
      return Forbid();
    }

    if (!string.Equals(record.Status, RentalPaymentStatuses.PendingCheckerApproval, StringComparison.OrdinalIgnoreCase))
    {
      return BadRequest(new { message = "Only pending rental payment requests can be rejected." });
    }

    var rejectionReason = (request.RejectionReason ?? string.Empty).Trim();
    if (string.IsNullOrWhiteSpace(rejectionReason))
    {
      return BadRequest(new { message = "Rejection reason is required." });
    }

    record.Status = RentalPaymentStatuses.Rejected;
    record.StatusMessage = rejectionReason;
    record.CheckerUserName = currentUser.Username;
    record.CheckerBranchCode = currentUser.BranchCode;
    record.CheckerComment = rejectionReason;
    record.RejectionReason = rejectionReason;
    record.RejectedAt = DateTimeOffset.UtcNow;
    record.ApprovedAt = null;
    record.UpdatedAt = DateTimeOffset.UtcNow;

    await dbContext.SaveChangesAsync(cancellationToken);

    await auditService.LogAsync(
      Guid.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!),
      null,
      "RENTAL_PAYMENT_REJECT",
      "RentalPaymentRequest",
      record.Id.ToString(),
      new { record.ManifestId, record.BillId, record.RejectionReason, record.CheckerUserName },
      HttpContext.Connection.RemoteIpAddress?.ToString(),
      cancellationToken
    );

    return Ok(Map(record));
  }

  [HttpGet("{id:int}")]
  [Authorize(Roles = UserRoles.RentalMaker + "," + UserRoles.RentalChecker)]
  public async Task<ActionResult<RentalPaymentRecordDto>> Get(int id, CancellationToken cancellationToken)
  {
    var currentUser = await GetCurrentUserAsync(cancellationToken);
    var record = await dbContext.RentalPaymentRequests.FirstOrDefaultAsync(x => x.Id == id, cancellationToken);
    if (record is null)
    {
      return NotFound(new { message = "Rental payment record was not found." });
    }

    if (!CanAccessRecord(currentUser, record))
    {
      return Forbid();
    }

    return Ok(Map(record));
  }

  private async Task<AppUser> GetCurrentUserAsync(CancellationToken cancellationToken)
  {
    var userId = Guid.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!);
    return await dbContext.Users.FirstAsync(x => x.Id == userId, cancellationToken);
  }

  private static bool CanAccessRecord(AppUser user, RentalPaymentRequest record)
  {
    if (string.Equals(user.Role, UserRoles.RentalMaker, StringComparison.OrdinalIgnoreCase))
    {
      return string.Equals(record.MakerUserName, user.Username, StringComparison.OrdinalIgnoreCase);
    }

    if (string.Equals(user.Role, UserRoles.RentalChecker, StringComparison.OrdinalIgnoreCase))
    {
      return CheckerCanAccess(record, user);
    }

    return false;
  }

  private static bool CheckerCanAccess(RentalPaymentRequest record, AppUser user)
  {
    return string.Equals(record.MakerBranchCode, user.BranchCode, StringComparison.OrdinalIgnoreCase);
  }

  private static string BuildManifestId()
  {
    var random = Random.Shared.Next(0, 10_000);
    return $"RNT{DateTime.UtcNow:yyMMddHHmmss}{random:D4}";
  }

  private static RentalPaymentRecordDto Map(RentalPaymentRequest record)
  {
    return new RentalPaymentRecordDto(
      record.Id,
      record.ManifestId,
      record.BillId,
      record.BalerId,
      record.CustomerId,
      record.CustomerName,
      record.TenantName,
      record.OwnerName,
      record.OwnerAccountNumber,
      record.PropertyName,
      record.BillDescription,
      record.Reason,
      record.AmountDue,
      record.BaseAmount,
      record.PenaltyAmount,
      record.PaidAmount,
      record.Status,
      record.StatusMessage,
      record.DebitAccount,
      record.PaymentMode,
      record.MakerUserName,
      record.MakerBranchCode,
      record.CheckerUserName,
      record.CheckerBranchCode,
      record.CheckerComment,
      record.ApprovedAt,
      record.RejectedAt,
      record.RejectionReason,
      record.CbsReference,
      record.ConfirmationCode,
      record.PaidAtLocation,
      record.TellerId,
      record.DueDate,
      record.PaidAt,
      record.CreatedAt,
      record.UpdatedAt
    );
  }

  private static string NormalizePaymentMode(string? value)
  {
    return string.Equals((value ?? string.Empty).Trim(), "CASH", StringComparison.OrdinalIgnoreCase)
      ? "CASH"
      : "ACCOUNT";
  }
}
