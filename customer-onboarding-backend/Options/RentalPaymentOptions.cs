namespace CustomerOnboarding.Backend.Options;

public class RentalPaymentOptions
{
  public string RentalBaseUrl { get; set; } = "http://172.16.1.24:5100";
  public string PaymentDetailsPath { get; set; } = "/api/payments/details";
  public string PaymentCallbackPath { get; set; } = "/api/payments/callback";
  public string CbsUrl { get; set; } = "http://10.1.200.153:7003/FCUBSRTService/FCUBSRTService";
  public string CashDebitGlAccount { get; set; } = "1011010";
  public string CbsSource { get; set; } = "CHQPNT";
  public string CbsUserId { get; set; } = "FCATOP";
  public string CbsProductCode { get; set; } = "FTRQ";
  public string Currency { get; set; } = "ETB";
}
