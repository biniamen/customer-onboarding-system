using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace CustomerOnboarding.Backend.Models;

[Table("TelebirrTransferRequests")]
public class TelebirrTransferRequest
{
  [Key]
  public int Id { get; set; }

  [Required, StringLength(13)]
  public string AccountNumber { get; set; } = string.Empty;

  [StringLength(3)]
  public string? AccountBranchCode { get; set; }

  [StringLength(150)]
  public string? CustomerName { get; set; }

  [Required, StringLength(12)]
  public string TelebirrShortCode { get; set; } = string.Empty;

  [StringLength(200)]
  public string? TelebirrOrganizationName { get; set; }

  [Column(TypeName = "numeric(18,2)")]
  public decimal Amount { get; set; }

  [Required, StringLength(3)]
  public string Currency { get; set; } = "ETB";

  [Required, StringLength(120)]
  public string Narration { get; set; } = string.Empty;

  [Required, StringLength(20)]
  public string Status { get; set; } = TelebirrTransferStatuses.Pending;

  public int? MakerBranchId { get; set; }

  [StringLength(150)]
  public string? MakerUserName { get; set; }

  [StringLength(150)]
  public string? CheckerUserName { get; set; }

  public DateTimeOffset CreatedAt { get; set; } = DateTimeOffset.UtcNow;
  public DateTimeOffset? ApprovedAt { get; set; }
  public DateTimeOffset? RejectedAt { get; set; }

  [StringLength(300)]
  public string? RejectionReason { get; set; }

  [StringLength(100)]
  public string? TransactionId { get; set; }

  [StringLength(100)]
  public string? ConversationId { get; set; }

  [StringLength(100)]
  public string? OriginatorConversationId { get; set; }

  [StringLength(100)]
  public string? CbsReference { get; set; }

  [StringLength(50)]
  public string? CbsMessageStatus { get; set; }

  [StringLength(500)]
  public string? CbsResponseDesc { get; set; }

  [StringLength(100)]
  public string? ReversalReference { get; set; }

  [StringLength(50)]
  public string? ReversalStatus { get; set; }

  [StringLength(500)]
  public string? ReversalResponseDesc { get; set; }

  [StringLength(50)]
  public string? ResponseCode { get; set; }

  [StringLength(500)]
  public string? ResponseDesc { get; set; }

  [StringLength(50)]
  public string? ServiceStatus { get; set; }

  [StringLength(50)]
  public string? ResultType { get; set; }

  [StringLength(50)]
  public string? ResultCode { get; set; }

  [StringLength(500)]
  public string? ResultDesc { get; set; }

  public string? RequestPayload { get; set; }
  public string? ResponsePayload { get; set; }
}
