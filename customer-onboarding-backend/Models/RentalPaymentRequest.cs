using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace CustomerOnboarding.Backend.Models;

[Table("RentalPaymentRequests")]
public class RentalPaymentRequest
{
  [Key]
  public int Id { get; set; }

  [Required]
  [StringLength(40)]
  public string ManifestId { get; set; } = string.Empty;

  [Required]
  [StringLength(80)]
  public string BillId { get; set; } = string.Empty;

  [Required]
  [StringLength(80)]
  public string BalerId { get; set; } = string.Empty;

  [StringLength(80)]
  public string? CustomerId { get; set; }

  [StringLength(200)]
  public string? CustomerName { get; set; }

  [StringLength(200)]
  public string? TenantName { get; set; }

  [StringLength(200)]
  public string? OwnerName { get; set; }

  [StringLength(32)]
  public string? OwnerAccountNumber { get; set; }

  [StringLength(200)]
  public string? PropertyName { get; set; }

  [StringLength(400)]
  public string? BillDescription { get; set; }

  [StringLength(500)]
  public string? Reason { get; set; }

  [Column(TypeName = "numeric(18,2)")]
  public decimal AmountDue { get; set; }

  [Column(TypeName = "numeric(18,2)")]
  public decimal BaseAmount { get; set; }

  [Column(TypeName = "numeric(18,2)")]
  public decimal PenaltyAmount { get; set; }

  [Column(TypeName = "numeric(18,2)")]
  public decimal? PaidAmount { get; set; }

  [Required]
  [StringLength(40)]
  public string Status { get; set; } = RentalPaymentStatuses.Unpaid;

  [StringLength(500)]
  public string? StatusMessage { get; set; }

  [StringLength(32)]
  public string? DebitAccount { get; set; }

  [StringLength(16)]
  public string? PaymentMode { get; set; }

  [StringLength(150)]
  public string? MakerUserName { get; set; }

  [StringLength(3)]
  public string? MakerBranchCode { get; set; }

  [StringLength(150)]
  public string? CheckerUserName { get; set; }

  [StringLength(3)]
  public string? CheckerBranchCode { get; set; }

  [StringLength(300)]
  public string? CheckerComment { get; set; }

  [StringLength(300)]
  public string? RejectionReason { get; set; }

  [StringLength(100)]
  public string? CbsReference { get; set; }

  [StringLength(100)]
  public string? ConfirmationCode { get; set; }

  [StringLength(120)]
  public string? PaidAtLocation { get; set; }

  [StringLength(64)]
  public string? TellerId { get; set; }

  public DateTimeOffset? DueDate { get; set; }
  public DateTimeOffset? PaidAt { get; set; }
  public DateTimeOffset? ApprovedAt { get; set; }
  public DateTimeOffset? RejectedAt { get; set; }
  public DateTimeOffset CreatedAt { get; set; } = DateTimeOffset.UtcNow;
  public DateTimeOffset UpdatedAt { get; set; } = DateTimeOffset.UtcNow;

  public string? RequestPayload { get; set; }
  public string? ResponsePayload { get; set; }
}
