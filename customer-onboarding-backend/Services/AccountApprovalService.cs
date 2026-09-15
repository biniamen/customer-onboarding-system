using System.Text;
using System.Text.Json;
using System.Xml.Linq;
using CustomerOnboarding.Backend.Models;
using CustomerOnboarding.Backend.Options;
using Microsoft.Extensions.Options;

namespace CustomerOnboarding.Backend.Services;

public class AccountApprovalService(
  HttpClient httpClient,
  IOptions<FcubsOptions> fcubsOptions) : IAccountApprovalService
{
  private readonly FcubsOptions _fcubsOptions = fcubsOptions.Value;

  public async Task<(bool Success, bool StatusChangeSuccess, string Message, string AccountNumber, string RawResponse)> CreateAccountAsync(OnboardingRecord record, CancellationToken cancellationToken = default)
  {
    var payload = BuildSoapEnvelope(record);
    using var request = new HttpRequestMessage(HttpMethod.Post, _fcubsOptions.AccountEndpoint);
    request.Content = new StringContent(payload, Encoding.UTF8, "text/xml");

    using var response = await httpClient.SendAsync(request, cancellationToken);
    var raw = await response.Content.ReadAsStringAsync(cancellationToken);

    var accountNumber = ExtractXmlValue(raw, "ACC");
    var errorCode = ExtractXmlValue(raw, "ECODE");
    var errorMessage = ExtractXmlValue(raw, "EDESC");
    var message = string.IsNullOrWhiteSpace(errorMessage)
      ? (string.IsNullOrWhiteSpace(accountNumber) ? "FCUBS account service returned no account number." : $"Account created successfully: {accountNumber}.")
      : $"{errorCode}: {errorMessage}".Trim(':', ' ');

    var accountCreated = !string.IsNullOrWhiteSpace(accountNumber) && string.IsNullOrWhiteSpace(errorMessage);
    if (!accountCreated)
    {
      return (false, false, message, accountNumber, raw);
    }

    // KYC approval creates the FCUBS account directly. No follow-up status change is sent.
    return (true, true, $"Account created successfully: {accountNumber}.", accountNumber, raw);
  }

  private string BuildSoapEnvelope(OnboardingRecord record)
  {
    var accountDetails = JsonDocument.Parse(record.AccountDetailsJson).RootElement;
    var accountClass = ReadJsonString(accountDetails, "accountClass") ?? record.AccountClass;
    var openingAmount = ReadJsonDecimal(accountDetails, "openingAmount");
    var fundingSourceType = ReadJsonString(accountDetails, "fundingSourceType") ?? "CASH";
    var accountReference = BuildAccountReference(record, accountDetails, accountClass);
    var payInOption = fundingSourceType.Equals("ACCOUNT", StringComparison.OrdinalIgnoreCase) ? "A" : "G";
    var accountType = ResolveAccountType(accountClass);

    return $@"<?xml version=""1.0"" encoding=""utf-8""?>
<soapenv:Envelope xmlns:soapenv=""http://schemas.xmlsoap.org/soap/envelope/"" xmlns:fcub=""http://fcubs.ofss.com/service/FCUBSAccService"">
  <soapenv:Header/>
  <soapenv:Body>
    <fcub:CREATECUSTACC_FSFS_REQ>
      <fcub:FCUBS_HEADER>
        <fcub:SOURCE>{EscapeXml(_fcubsOptions.Source)}</fcub:SOURCE>
        <fcub:UBSCOMP>{EscapeXml(_fcubsOptions.UbsComp)}</fcub:UBSCOMP>
        <fcub:USERID>{EscapeXml(_fcubsOptions.UserId)}</fcub:USERID>
        <fcub:BRANCH>{EscapeXml(record.BranchCode)}</fcub:BRANCH>
        <fcub:SERVICE>{EscapeXml(_fcubsOptions.Service)}</fcub:SERVICE>
        <fcub:OPERATION>{EscapeXml(_fcubsOptions.Operation)}</fcub:OPERATION>
      </fcub:FCUBS_HEADER>
      <fcub:FCUBS_BODY>
        <fcub:Cust-Account-Full>
          <fcub:BRN>{EscapeXml(record.BranchCode)}</fcub:BRN>
          <fcub:ACC>{EscapeXml(accountReference ?? string.Empty)}</fcub:ACC>
          <fcub:CUSTNO>{EscapeXml(record.CustomerNumber)}</fcub:CUSTNO>
          <fcub:ACCLS>{EscapeXml(accountClass)}</fcub:ACCLS>
          <fcub:CCY>{EscapeXml(_fcubsOptions.Currency)}</fcub:CCY>
          <fcub:PAY_IN_OPTION>{EscapeXml(payInOption)}</fcub:PAY_IN_OPTION>
          <fcub:ACC_OPENING_AMT>{openingAmount:0.##}</fcub:ACC_OPENING_AMT>
          <fcub:LOC>{EscapeXml(_fcubsOptions.Location)}</fcub:LOC>
          <fcub:MEDIA>{EscapeXml(_fcubsOptions.Media)}</fcub:MEDIA>
          <fcub:ACCTYPE>{EscapeXml(accountType)}</fcub:ACCTYPE>
        </fcub:Cust-Account-Full>
      </fcub:FCUBS_BODY>
    </fcub:CREATECUSTACC_FSFS_REQ>
  </soapenv:Body>
</soapenv:Envelope>";
  }

  private string BuildAccountReference(OnboardingRecord record, JsonElement accountDetails, string accountClass)
  {
    var branchCode = record.BranchCode;
    var accountCode = ResolveAccountCode(accountClass, accountDetails, record.AccountReference);
    return $"{branchCode}{accountCode}CCCCS";
  }

  private string ResolveAccountCode(string accountClass, JsonElement accountDetails, string? existingReference)
  {
    if (TryGetJsonProperty(accountDetails, "accountCode", out var accountCodeElement))
    {
      var accountCode = accountCodeElement.GetString()?.Trim();
      if (!string.IsNullOrWhiteSpace(accountCode))
      {
        return accountCode;
      }
    }

    if (_fcubsOptions.AccountClassCodes.TryGetValue(accountClass ?? string.Empty, out var mappedCode) &&
        !string.IsNullOrWhiteSpace(mappedCode))
    {
      return mappedCode.Trim();
    }

    if (!string.IsNullOrWhiteSpace(existingReference))
    {
      var digitsOnly = new string(existingReference.Where(char.IsDigit).ToArray());
      if (digitsOnly.Length >= 5)
      {
        return digitsOnly.Substring(3, 2);
      }
    }

    return _fcubsOptions.DefaultAccountCode;
  }

  private static string ResolveAccountType(string accountClass)
  {
    var normalized = (accountClass ?? string.Empty).ToUpperInvariant();
    if (normalized.StartsWith("C") || normalized.StartsWith("WC")) return "C";
    if (normalized.StartsWith("TD") || normalized.StartsWith("TE")) return "T";
    return "S";
  }

  private static string ExtractXmlValue(string xmlText, string localName)
  {
    try
    {
      var document = XDocument.Parse(xmlText);
      return document.Descendants().FirstOrDefault(x => x.Name.LocalName == localName)?.Value?.Trim() ?? string.Empty;
    }
    catch
    {
      return string.Empty;
    }
  }

  private static string EscapeXml(string value)
  {
    return value
      .Replace("&", "&amp;")
      .Replace("<", "&lt;")
      .Replace(">", "&gt;")
      .Replace("\"", "&quot;")
      .Replace("'", "&apos;");
  }

  private static bool TryGetJsonProperty(JsonElement element, string propertyName, out JsonElement value)
  {
    if (element.TryGetProperty(propertyName, out value))
    {
      return true;
    }

    var pascalName = char.ToUpperInvariant(propertyName[0]) + propertyName[1..];
    return element.TryGetProperty(pascalName, out value);
  }

  private static string? ReadJsonString(JsonElement element, string propertyName)
  {
    return TryGetJsonProperty(element, propertyName, out var value)
      ? value.GetString()
      : null;
  }

  private static decimal ReadJsonDecimal(JsonElement element, string propertyName)
  {
    if (!TryGetJsonProperty(element, propertyName, out var value))
    {
      return 0m;
    }

    return value.ValueKind switch
    {
      JsonValueKind.Number when value.TryGetDecimal(out var number) => number,
      JsonValueKind.String when decimal.TryParse(value.GetString(), out var number) => number,
      _ => 0m
    };
  }
}
