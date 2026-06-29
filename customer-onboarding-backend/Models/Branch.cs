using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace CustomerOnboarding.Backend.Models;

[Table("Branches")]
public class Branch
{
  [Key, StringLength(3)]
  public string BranchCode { get; set; } = string.Empty;

  [Required, StringLength(120)]
  public string BranchName { get; set; } = string.Empty;

  public bool IsActive { get; set; } = true;
}
