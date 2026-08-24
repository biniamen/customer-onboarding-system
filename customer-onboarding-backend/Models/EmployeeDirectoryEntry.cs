namespace CustomerOnboarding.Backend.Models;

public class EmployeeDirectoryEntry
{
  public Guid Id { get; set; } = Guid.NewGuid();
  public int SourceRowNumber { get; set; }
  public int? SequenceNumber { get; set; }
  public string FullName { get; set; } = string.Empty;
  public string FirstName { get; set; } = string.Empty;
  public string MiddleName { get; set; } = string.Empty;
  public string LastName { get; set; } = string.Empty;
  public string EmployeeCode { get; set; } = string.Empty;
  public string InternalNumber { get; set; } = string.Empty;
  public string InternalNumberExtension { get; set; } = string.Empty;
  public string EmployeeReference { get; set; } = string.Empty;
  public string Gender { get; set; } = string.Empty;
  public string ContactAddress { get; set; } = string.Empty;
  public string PhoneNumber { get; set; } = string.Empty;
  public string PhoneNumberNormalized { get; set; } = string.Empty;
  public string CurrentPosition { get; set; } = string.Empty;
  public string Classification { get; set; } = string.Empty;
  public string AssignedUnitName { get; set; } = string.Empty;
  public string BranchGrade { get; set; } = string.Empty;
  public string BranchCode { get; set; } = string.Empty;
  public string District { get; set; } = string.Empty;
  public DateOnly? EmploymentDate { get; set; }
  public bool IsActive { get; set; } = true;
  public string SourceFileName { get; set; } = string.Empty;
  public string SourceSheetName { get; set; } = string.Empty;
  public DateTimeOffset ImportedAtUtc { get; set; } = DateTimeOffset.UtcNow;
  public DateTimeOffset UpdatedAtUtc { get; set; } = DateTimeOffset.UtcNow;
}
