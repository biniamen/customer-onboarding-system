namespace CustomerOnboarding.Backend.Options;

public class TelebirrOptions
{
  public string LookupEndpoint { get; set; } = string.Empty;
  public string PaymentEndpoint { get; set; } = string.Empty;
  public string Version { get; set; } = "1.0";
  public int KeyOwner { get; set; } = 1;

  public string LookupCommandId { get; set; } = "QueryOrganizationInfo";
  public int LookupCallerType { get; set; } = 2;
  public string LookupThirdPartyId { get; set; } = "Query";
  public string LookupCallerPassword { get; set; } = string.Empty;
  public int LookupInitiatorIdentifierType { get; set; } = 14;
  public string LookupInitiatorIdentifier { get; set; } = "Bankquery";
  public string LookupInitiatorSecurityCredential { get; set; } = string.Empty;
  public int LookupReceiverIdentifierType { get; set; } = 4;
  public string LookupRemark { get; set; } = "Agent verification";

  public string PaymentCommandId { get; set; } = "InitTrans_DepositfromBankOrg";
  public int PaymentCallerType { get; set; } = 2;
  public string PaymentThirdPartyId { get; set; } = "Debub_Bank";
  public string PaymentCallerPassword { get; set; } = string.Empty;
  public string PaymentResultUrl { get; set; } = string.Empty;
  public int PaymentInitiatorIdentifierType { get; set; } = 12;
  public string PaymentInitiatorIdentifier { get; set; } = "000241";
  public string PaymentInitiatorSecurityCredential { get; set; } = string.Empty;
  public string PaymentInitiatorShortCode { get; set; } = "00024";
  public int PaymentReceiverIdentifierType { get; set; } = 4;
  public string PaymentRemarkPrefix { get; set; } = "TLBO";
  public string PaymentCurrency { get; set; } = "ETB";
}
