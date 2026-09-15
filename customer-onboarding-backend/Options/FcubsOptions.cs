namespace CustomerOnboarding.Backend.Options;

public class FcubsOptions
{
  public string Source { get; set; } = "PAP";
  public string UbsComp { get; set; } = "FCUBS";
  public string UserId { get; set; } = "ESBUSER";
  public string BranchCode { get; set; } = "109";
  public string Service { get; set; } = "FCUBSAccService";
  public string Operation { get; set; } = "CreateCustAcc";
  public string AccountEndpoint { get; set; } = string.Empty;
  public string CustomerEndpoint { get; set; } = string.Empty;
  public string CustomerImageSignatureEndpoint { get; set; } = string.Empty;
  public string StatusChangeEndpoint { get; set; } = string.Empty;
  public string StatusChangeService { get; set; } = "FCUBSSTService";
  public string StatusChangeOperation { get; set; } = "CreateManStatChange";
  public int StatusChangeRetryCount { get; set; } = 4;
  public int StatusChangeRetryDelaySeconds { get; set; } = 2;
  public string QueryEndpoint { get; set; } = string.Empty;
  public string QuerySource { get; set; } = "IPS";
  public string QueryUserId { get; set; } = "IPSUSER";
  public string QueryModuleId { get; set; } = "AC";
  public string QueryService { get; set; } = "FCUBSAccService";
  public string QueryOperation { get; set; } = "QueryCustAcc";
  public string QuerySourceOperation { get; set; } = "QueryCustAcc";
  public string QuerySourceUserId { get; set; } = "IPSUSER";
  public string RtEndpoint { get; set; } = string.Empty;
  public string RtSource { get; set; } = "CHQPNT";
  public string RtUserId { get; set; } = "ESBUSER";
  public string RtBranch { get; set; } = "109";
  public string RtService { get; set; } = "FCUBSRTService";
  public string RtOperation { get; set; } = "CreateTransaction";
  public string RtProductCode { get; set; } = "TLBM";
  public string RtCurrency { get; set; } = "ETB";
  public string RtOffsetBranch { get; set; } = "109";
  public string RtOffsetAccount { get; set; } = "2022660";
  public string RtReversalSource { get; set; } = "VTM";
  public string RtReversalUserId { get; set; } = "ESBUSER";
  public string RtReversalService { get; set; } = "FCUBSRTService";
  public string RtReversalOperation { get; set; } = "ReverseTransaction";
  public string RtReversalModule { get; set; } = "RT";
  public string RtReversalProductCode { get; set; } = "CHDP";
  public string Media { get; set; } = "MAIL";
  public string Location { get; set; } = "AA";
  // FCUBS validates the customer category as a code, not its display description.
  public string CustomerCategory { get; set; } = "IND";
  public string MinorCustomerCategory { get; set; } = "MINOR";
  public string Currency { get; set; } = "ETB";
  public string DefaultAccountCode { get; set; } = "73";
  public decimal MinimumRemainingBalance { get; set; } = 50m;
  public Dictionary<string, string> AccountClassCodes { get; set; } = new(StringComparer.OrdinalIgnoreCase);
}
