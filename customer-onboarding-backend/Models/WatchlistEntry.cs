using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace CustomerOnboarding.Backend.Models;

[Table("WatchlistEntries")]
public class WatchlistEntry
{
  [Key]
  public Guid Id { get; set; } = Guid.NewGuid();

  [Required]
  [StringLength(64)]
  public string EntryKey { get; set; } = string.Empty;

  [Required]
  [StringLength(240)]
  public string FullName { get; set; } = string.Empty;

  [Required]
  [StringLength(240)]
  public string NormalizedName { get; set; } = string.Empty;

  public string? AlternateNames { get; set; }

  [Required]
  [StringLength(40)]
  public string ScreeningCategory { get; set; } = string.Empty;

  [Required]
  [StringLength(160)]
  public string SourceList { get; set; } = string.Empty;

  [StringLength(160)]
  public string? SourceReference { get; set; }

  [StringLength(40)]
  public string? RiskLevel { get; set; }

  [StringLength(120)]
  public string? Nationality { get; set; }

  public DateOnly? DateOfBirth { get; set; }

  [StringLength(160)]
  public string? PlaceOfBirth { get; set; }

  [StringLength(100)]
  public string? DocumentType { get; set; }

  [StringLength(160)]
  public string? DocumentNumber { get; set; }

  [StringLength(240)]
  public string? PositionOrRole { get; set; }

  [StringLength(240)]
  public string? Organization { get; set; }

  [StringLength(120)]
  public string? Country { get; set; }

  [StringLength(160)]
  public string? CityOrRegion { get; set; }

  public string? Address { get; set; }
  public DateOnly? ListedOn { get; set; }
  public DateOnly? ExpiryDate { get; set; }
  public bool IsActive { get; set; } = true;
  public bool IsPep { get; set; }
  public bool IsSanctioned { get; set; }
  public bool RequiresEnhancedDueDiligence { get; set; }
  public string? Remarks { get; set; }

  [StringLength(500)]
  public string? SourceUrl { get; set; }

  public string? SourceDataJson { get; set; }

  [StringLength(260)]
  public string? ImportedFileName { get; set; }

  public int? SourceRowNumber { get; set; }

  [StringLength(150)]
  public string? CreatedByUserName { get; set; }

  [StringLength(150)]
  public string? UpdatedByUserName { get; set; }

  public DateTimeOffset CreatedAtUtc { get; set; } = DateTimeOffset.UtcNow;
  public DateTimeOffset UpdatedAtUtc { get; set; } = DateTimeOffset.UtcNow;
}
