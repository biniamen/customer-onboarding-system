using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace CustomerOnboarding.Backend.Models;

[Table("ResourceMobilizationRecords")]
public class ResourceMobilizationRecord
{
  [Key]
  public int Id { get; set; }

  [Required]
  [StringLength(40)]
  public string RegistrationReference { get; set; } = string.Empty;

  [Required]
  [StringLength(40)]
  public string RegistrationBatchReference { get; set; } = string.Empty;

  public Guid? EmployeeDirectoryEntryId { get; set; }

  public bool IsJointRegistration { get; set; }

  public int JointParticipantCount { get; set; } = 1;

  public int JointSequenceNumber { get; set; } = 1;

  [Required]
  [StringLength(96)]
  public string EmployeeReference { get; set; } = string.Empty;

  [Required]
  [StringLength(220)]
  public string EmployeeFullName { get; set; } = string.Empty;

  [StringLength(32)]
  public string? EmployeePhoneNumber { get; set; }

  [StringLength(32)]
  public string? EmployeeBranchCode { get; set; }

  [StringLength(220)]
  public string? EmployeeBranchName { get; set; }

  [StringLength(220)]
  public string? EmployeeDepartmentName { get; set; }

  [StringLength(220)]
  public string? EmployeePositionName { get; set; }

  [StringLength(80)]
  public string? EmployeeClassification { get; set; }

  [Column(TypeName = "numeric(18,2)")]
  public decimal MonthlyTargetAmount { get; set; }

  [Required]
  [StringLength(16)]
  public string DepositProductType { get; set; } = string.Empty;

  [Column(TypeName = "numeric(18,2)")]
  public decimal SourceTransactionAmount { get; set; }

  [Column(TypeName = "numeric(18,2)")]
  public decimal TotalDepositMobilized { get; set; }

  public int NewAccountCount { get; set; }

  [Required]
  [StringLength(220)]
  public string DepositorCustomerName { get; set; } = string.Empty;

  [StringLength(40)]
  public string? DepositorCustomerNumber { get; set; }

  [Required]
  [StringLength(32)]
  public string DepositorAccountNumber { get; set; } = string.Empty;

  [StringLength(32)]
  public string? DepositorAccountClass { get; set; }

  [Required]
  [StringLength(80)]
  public string TransactionReferenceNo { get; set; } = string.Empty;

  [Required]
  [StringLength(32)]
  public string DepositBranchCode { get; set; } = string.Empty;

  [StringLength(220)]
  public string? DepositBranchName { get; set; }

  [Required]
  [StringLength(8)]
  public string TransactionCurrency { get; set; } = "ETB";

  public DateTimeOffset TransactionValueDate { get; set; }

  [Required]
  [StringLength(40)]
  public string Status { get; set; } = ResourceMobilizationStatuses.PendingCheckerApproval;

  [StringLength(150)]
  public string? MakerUserName { get; set; }

  [StringLength(32)]
  public string? MakerBranchCode { get; set; }

  [StringLength(120)]
  public string? MakerBranchName { get; set; }

  [StringLength(150)]
  public string? CheckerUserName { get; set; }

  [StringLength(32)]
  public string? CheckerBranchCode { get; set; }

  [StringLength(120)]
  public string? CheckerBranchName { get; set; }

  [StringLength(300)]
  public string? CheckerComment { get; set; }

  [StringLength(300)]
  public string? RejectionReason { get; set; }

  public DateTimeOffset CreatedAt { get; set; } = DateTimeOffset.UtcNow;
  public DateTimeOffset UpdatedAt { get; set; } = DateTimeOffset.UtcNow;
  public DateTimeOffset? ApprovedAt { get; set; }
  public DateTimeOffset? RejectedAt { get; set; }

  public string? RequestPayload { get; set; }
  public string? ResponsePayload { get; set; }
}
