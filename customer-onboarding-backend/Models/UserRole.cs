namespace CustomerOnboarding.Backend.Models;

public static class UserRoles
{
  public const string Admin = "ADMIN";
  public const string SystemAdmin = "SYSTEM_ADMIN";
  public const string SeniorManagement = "SENIOR_MANAGEMENT";
  public const string BranchBanking = "BRANCH_BANKING";
  public const string Hr = "HR";
  public const string Maker = "MAKER";
  public const string Checker = "CHECKER";
  public const string RentalMaker = "RENTAL_MAKER";
  public const string RentalChecker = "RENTAL_CHECKER";
  public const string ReportViewer = "REPORT_VIEWER";
  public const string KycUnit = "KYC_UNIT";

  public static readonly IReadOnlyList<string> All =
  [
    Admin,
    SystemAdmin,
    SeniorManagement,
    BranchBanking,
    Hr,
    Maker,
    Checker,
    RentalMaker,
    RentalChecker,
    ReportViewer,
    KycUnit
  ];
}
