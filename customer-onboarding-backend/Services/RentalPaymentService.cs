using System.Globalization;
using System.Text;
using System.Text.Json;
using System.Xml.Linq;
using CustomerOnboarding.Backend.Models;
using CustomerOnboarding.Backend.Options;
using Microsoft.Extensions.Options;

namespace CustomerOnboarding.Backend.Services;

public class RentalPaymentService(
  HttpClient httpClient,
  IOptions<RentalPaymentOptions> rentalOptions
) : IRentalPaymentService
{
  private readonly RentalPaymentOptions _options = rentalOptions.Value;

  public async Task<RentalInquiryResult> InquireAsync(string billId, string balerId, CancellationToken cancellationToken = default)
  {
    if (string.IsNullOrWhiteSpace(_options.RentalBaseUrl))
    {
      return new RentalInquiryResult(
        false,
        "Rental payment service is not configured.",
        billId,
        balerId,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        0m,
        0m,
        0m,
        null,
        null,
        false,
        null,
        string.Empty
      );
    }

    var requestUri = $"{_options.RentalBaseUrl.TrimEnd('/')}{_options.PaymentDetailsPath}?billId={Uri.EscapeDataString(billId.Trim())}&balerId={Uri.EscapeDataString(balerId.Trim())}";
    using var response = await httpClient.GetAsync(requestUri, cancellationToken);
    var raw = await response.Content.ReadAsStringAsync(cancellationToken);

    if (!response.IsSuccessStatusCode)
    {
      return new RentalInquiryResult(
        false,
        $"Rental service returned HTTP {(int)response.StatusCode}.",
        billId,
        balerId,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        0m,
        0m,
        0m,
        null,
        null,
        false,
        null,
        raw
      );
    }

    try
    {
      using var document = JsonDocument.Parse(raw);
      var root = document.RootElement;

      var responseBillId = ReadString(root, "BillId", "billId") ?? billId.Trim();
      var responseBalerId = ReadString(root, "BalerId", "balerId") ?? balerId.Trim();
      var status = (ReadString(root, "Status", "status") ?? string.Empty).Trim();
      var tenantName = ReadString(root, "TenantName", "tenantName");
      var ownerName = ReadString(root, "OwnerName", "ownerName");
      var ownerAccountNumber = ReadString(root, "OwnerAccountNumber", "ownerAccountNumber");
      var propertyName = ReadString(root, "PropertyName", "propertyName");
      var description = ReadString(root, "Description", "description");
      var customerId = ReadString(root, "CustomerId", "customerId");
      var currentPeriod = ReadString(root, "CurrentPeriod", "currentPeriod");
      var penaltyType = ReadString(root, "PenaltyType", "penaltyType");
      var penaltyAmount = ReadDecimal(root, "PenaltyAmount", "penaltyAmount");
      var baseAmount = ReadDecimal(root, "Amount", "amount", "AmountDue", "amountDue");
      var totalAmount = ReadDecimal(root, "TotalAmount", "totalAmount");
      var customerName = FirstNonEmpty(
        ReadString(root, "CustomerName", "customerName"),
        tenantName
      );
      var amountDue = totalAmount > 0 ? totalAmount : baseAmount;
      var dueDate = ReadDate(root, "DueDate", "dueDate");
      var isOverdue = ReadBoolean(root, "IsOverdue", "isOverdue") ?? status.Equals("overdue", StringComparison.OrdinalIgnoreCase);
      var reason = string.IsNullOrWhiteSpace(propertyName)
        ? $"Rental payment for {FirstNonEmpty(tenantName, responseBillId)}"
        : $"Rent payment for {propertyName} (Tenant: {FirstNonEmpty(tenantName, "N/A")}, Owner: {FirstNonEmpty(ownerName, "N/A")})";
      if (!string.IsNullOrWhiteSpace(currentPeriod))
      {
        reason = $"{reason} - Period: {currentPeriod}";
      }
      var billDescription = string.IsNullOrWhiteSpace(propertyName)
        ? FirstNonEmpty(description, "Rental payment")
        : $"{FirstNonEmpty(description, "Rental payment")} (Property: {propertyName})";

      var canProceed = status.Equals("pending", StringComparison.OrdinalIgnoreCase) ||
                       status.Equals("due", StringComparison.OrdinalIgnoreCase) ||
                       status.Equals("overdue", StringComparison.OrdinalIgnoreCase) ||
                       isOverdue;

      if (canProceed && string.IsNullOrWhiteSpace(ownerAccountNumber))
      {
        canProceed = false;
      }

      if (canProceed && amountDue <= 0)
      {
        canProceed = false;
      }

      var message = canProceed
        ? "Pending rental bill retrieved successfully."
        : string.IsNullOrWhiteSpace(ownerAccountNumber)
          ? "Rental bill cannot be processed because the owner account number is missing."
          : amountDue <= 0
            ? "Rental bill cannot be processed because the payable amount is zero."
            : $"Rental bill is not payable because the current status is '{status}'.";

      return new RentalInquiryResult(
        canProceed,
        message,
        responseBillId,
        responseBalerId,
        customerId,
        customerName,
        tenantName,
        ownerName,
        ownerAccountNumber,
        propertyName,
        billDescription,
        reason,
        amountDue,
        baseAmount,
        penaltyAmount,
        currentPeriod,
        penaltyType,
        isOverdue,
        dueDate,
        raw
      );
    }
    catch (Exception ex)
    {
      return new RentalInquiryResult(
        false,
        $"Unable to parse the rental service response. {ex.Message}",
        billId,
        balerId,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        0m,
        0m,
        0m,
        null,
        null,
        false,
        null,
        raw
      );
    }
  }

  public async Task<RentalPaymentProcessingResult> ProcessPaymentAsync(RentalPaymentRequest record, string paymentMode, string? debitAccount, string makerBranchCode, decimal amount, string paidAt, string? tellerId, CancellationToken cancellationToken = default)
  {
    var resolvedPaymentMode = NormalizePaymentMode(paymentMode);
    var resolvedDebitAccount = ResolveDebitAccount(resolvedPaymentMode, debitAccount);
    if (string.IsNullOrWhiteSpace(record.OwnerAccountNumber))
    {
      return new RentalPaymentProcessingResult(
        false,
        RentalPaymentStatuses.CbsConfirmationRequired,
        "Owner account number was not returned by the rental service, so CBS posting could not continue.",
        null,
        null,
        amount,
        null,
        string.Empty,
        string.Empty
      );
    }

    var cbsPayload = BuildCbsPayload(
      resolvedPaymentMode,
      makerBranchCode,
      resolvedDebitAccount,
      record.OwnerAccountNumber,
      amount,
      BuildNarrative(record)
    );
    var cbsResult = await SendSoapAsync(_options.CbsUrl, cbsPayload, cancellationToken);
    var cbsStatus = ExtractXmlValue(cbsResult.RawResponse, "MSGSTAT");
    var cbsReference = FirstNonEmpty(
      ExtractXmlValue(cbsResult.RawResponse, "XREF"),
      ExtractXmlValue(cbsResult.RawResponse, "FCCREF")
    );
    var cbsError = BuildMessage("CBS posting failed.", ExtractXmlValue(cbsResult.RawResponse, "ECODE"), ExtractXmlValue(cbsResult.RawResponse, "EDESC"), cbsStatus);

    if (!cbsResult.Success || !string.Equals(cbsStatus, "SUCCESS", StringComparison.OrdinalIgnoreCase) || string.IsNullOrWhiteSpace(cbsReference))
    {
      return new RentalPaymentProcessingResult(
        false,
        RentalPaymentStatuses.CbsConfirmationRequired,
        cbsError,
        cbsReference,
        null,
        amount,
        null,
        BuildPayloadAudit(("CBS_POSTING", cbsPayload)),
        BuildPayloadAudit(("CBS_RESPONSE", cbsResult.RawResponse))
      );
    }

    var paidAtUtc = DateTimeOffset.UtcNow;
    var callbackPayload = JsonSerializer.Serialize(new
    {
      TransactionId = cbsReference,
      Status = "completed",
      GatewayReference = cbsReference,
      ProcessedAt = paidAtUtc.ToString("yyyy-MM-dd", CultureInfo.InvariantCulture),
      FailureReason = string.Empty,
      ActualAmount = amount,
      BillId = record.BillId,
      BalerId = record.BalerId
    });

    var callbackResult = await SendJsonAsync($"{_options.RentalBaseUrl.TrimEnd('/')}{_options.PaymentCallbackPath}", callbackPayload, cancellationToken);

    var callbackSuccess = false;
    var callbackMessage = string.Empty;
    if (callbackResult.Success)
    {
      try
      {
        using var responseDocument = JsonDocument.Parse(callbackResult.RawResponse);
        var root = responseDocument.RootElement;
        callbackSuccess = ReadBoolean(root, "success", "Success") ??
                          string.Equals(ReadString(root, "status", "Status"), "completed", StringComparison.OrdinalIgnoreCase) ||
                          !string.IsNullOrWhiteSpace(ReadString(root, "transactionId", "TransactionId"));
        callbackMessage = FirstNonEmpty(
          ReadString(root, "message", "Message"),
          ReadString(root, "description", "Description"),
          ReadString(root, "status", "Status")
        );
      }
      catch
      {
        callbackSuccess = false;
      }
    }

    if (!callbackSuccess)
    {
      return new RentalPaymentProcessingResult(
        false,
        RentalPaymentStatuses.CbsPostedCallbackPending,
        string.IsNullOrWhiteSpace(callbackResult.RawResponse)
          ? "CBS payment was successful, but rental callback confirmation is still pending."
          : $"CBS payment was successful, but rental callback confirmation is still pending. Rental response: {FirstNonEmpty(callbackMessage, callbackResult.RawResponse)}",
        cbsReference,
        null,
        amount,
        paidAtUtc,
        BuildPayloadAudit(
          ("CBS_POSTING", cbsPayload),
          ("RENTAL_CALLBACK", callbackPayload)
        ),
        BuildPayloadAudit(
          ("CBS_RESPONSE", cbsResult.RawResponse),
          ("RENTAL_CALLBACK_RESPONSE", callbackResult.RawResponse)
        )
      );
    }

    return new RentalPaymentProcessingResult(
      true,
      RentalPaymentStatuses.Paid,
      "Rental payment posted to CBS and confirmed by the rental service.",
      cbsReference,
      record.BillId,
      amount,
      paidAtUtc,
      BuildPayloadAudit(
        ("CBS_POSTING", cbsPayload),
        ("RENTAL_CALLBACK", callbackPayload)
      ),
      BuildPayloadAudit(
        ("CBS_RESPONSE", cbsResult.RawResponse),
        ("RENTAL_CALLBACK_RESPONSE", callbackResult.RawResponse)
      )
    );
  }

  private async Task<(bool Success, string RawResponse)> SendSoapAsync(string endpoint, string payload, CancellationToken cancellationToken)
  {
    using var request = new HttpRequestMessage(HttpMethod.Post, endpoint);
    request.Content = new StringContent(payload, Encoding.UTF8, "text/xml");
    using var response = await httpClient.SendAsync(request, cancellationToken);
    var raw = await response.Content.ReadAsStringAsync(cancellationToken);
    return (response.IsSuccessStatusCode, raw);
  }

  private async Task<(bool Success, string RawResponse)> SendJsonAsync(string endpoint, string payload, CancellationToken cancellationToken)
  {
    using var request = new HttpRequestMessage(HttpMethod.Post, endpoint);
    request.Content = new StringContent(payload, Encoding.UTF8, "application/json");
    using var response = await httpClient.SendAsync(request, cancellationToken);
    var raw = await response.Content.ReadAsStringAsync(cancellationToken);
    return (response.IsSuccessStatusCode, raw);
  }

  private string BuildCbsPayload(string paymentMode, string makerBranchCode, string debitAccount, string creditAccount, decimal amount, string narrative)
  {
    var trimmedDebitAccount = debitAccount.Trim();
    var trimmedCreditAccount = creditAccount.Trim();
    var debitBranch = paymentMode == "CASH"
      ? NormalizeBranch(makerBranchCode, "000")
      : NormalizeBranch(trimmedDebitAccount[..3], "000");
    var creditBranch = trimmedCreditAccount.Length >= 3
      ? NormalizeBranch(trimmedCreditAccount[..3], "000")
      : "000";
    var transactionDate = DateTime.UtcNow.ToString("yyyy-MM-dd", CultureInfo.InvariantCulture);

    return $@"<?xml version=""1.0"" encoding=""UTF-8""?>
<soapenv:Envelope xmlns:soapenv=""http://schemas.xmlsoap.org/soap/envelope/"" xmlns:fcub=""http://fcubs.ofss.com/service/FCUBSRTService"">
  <soapenv:Header/>
  <soapenv:Body>
    <fcub:CREATETRANSACTION_FSFS_REQ>
      <fcub:FCUBS_HEADER>
        <fcub:SOURCE>{EscapeXml(_options.CbsSource)}</fcub:SOURCE>
        <fcub:UBSCOMP>FCUBS</fcub:UBSCOMP>
        <fcub:USERID>{EscapeXml(_options.CbsUserId)}</fcub:USERID>
        <fcub:BRANCH>{EscapeXml(debitBranch)}</fcub:BRANCH>
        <fcub:SERVICE>FCUBSRTService</fcub:SERVICE>
        <fcub:OPERATION>CreateTransaction</fcub:OPERATION>
      </fcub:FCUBS_HEADER>
      <fcub:FCUBS_BODY>
        <fcub:Transaction-Details>
          <fcub:PRD>{EscapeXml(_options.CbsProductCode)}</fcub:PRD>
          <fcub:BRN>{EscapeXml(debitBranch)}</fcub:BRN>
          <fcub:TXNBRN>{EscapeXml(debitBranch)}</fcub:TXNBRN>
          <fcub:TXNACC>{EscapeXml(trimmedDebitAccount)}</fcub:TXNACC>
          <fcub:TXNCCY>{EscapeXml(_options.Currency)}</fcub:TXNCCY>
          <fcub:TXNAMT>{amount.ToString("0.##", CultureInfo.InvariantCulture)}</fcub:TXNAMT>
          <fcub:OFFSETBRN>{EscapeXml(creditBranch)}</fcub:OFFSETBRN>
          <fcub:OFFSETACC>{EscapeXml(trimmedCreditAccount)}</fcub:OFFSETACC>
          <fcub:OFFSETCCY>{EscapeXml(_options.Currency)}</fcub:OFFSETCCY>
          <fcub:TXNDATE>{transactionDate}</fcub:TXNDATE>
          <fcub:VALDATE>{transactionDate}</fcub:VALDATE>
          <fcub:NARRATIVE>{EscapeXml(narrative)}</fcub:NARRATIVE>
        </fcub:Transaction-Details>
      </fcub:FCUBS_BODY>
    </fcub:CREATETRANSACTION_FSFS_REQ>
  </soapenv:Body>
</soapenv:Envelope>";
  }

  private static string? ReadString(JsonElement element, params string[] names)
  {
    foreach (var name in names)
    {
      if (TryGetPropertyIgnoreCase(element, name, out var property))
      {
        if (property.ValueKind == JsonValueKind.String)
        {
          return property.GetString();
        }

        if (property.ValueKind is JsonValueKind.Number or JsonValueKind.True or JsonValueKind.False)
        {
          return property.ToString();
        }
      }
    }

    return null;
  }

  private static bool? ReadBoolean(JsonElement element, params string[] names)
  {
    foreach (var name in names)
    {
      if (TryGetPropertyIgnoreCase(element, name, out var property))
      {
        if (property.ValueKind == JsonValueKind.True)
        {
          return true;
        }

        if (property.ValueKind == JsonValueKind.False)
        {
          return false;
        }

        if (property.ValueKind == JsonValueKind.String &&
            bool.TryParse(property.GetString(), out var parsedBoolean))
        {
          return parsedBoolean;
        }
      }
    }

    return null;
  }

  private static decimal ReadDecimal(JsonElement element, params string[] names)
  {
    foreach (var name in names)
    {
      if (TryGetPropertyIgnoreCase(element, name, out var property))
      {
        if (property.ValueKind == JsonValueKind.Number && property.TryGetDecimal(out var directValue))
        {
          return directValue;
        }

        if (property.ValueKind == JsonValueKind.String &&
            decimal.TryParse(property.GetString(), NumberStyles.Any, CultureInfo.InvariantCulture, out var parsedValue))
        {
          return parsedValue;
        }
      }
    }

    return 0m;
  }

  private static DateTimeOffset? ReadDate(JsonElement element, params string[] names)
  {
    foreach (var name in names)
    {
      if (TryGetPropertyIgnoreCase(element, name, out var property) &&
          property.ValueKind == JsonValueKind.String &&
          DateTimeOffset.TryParse(property.GetString(), CultureInfo.InvariantCulture, DateTimeStyles.AssumeUniversal, out var parsedDate))
      {
        return parsedDate.ToUniversalTime();
      }
    }

    return null;
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
    return (value ?? string.Empty)
      .Replace("&", "&amp;")
      .Replace("<", "&lt;")
      .Replace(">", "&gt;")
      .Replace("\"", "&quot;")
      .Replace("'", "&apos;");
  }

  private static string BuildMessage(string fallback, string errorCode, string errorDescription, string status)
  {
    var details = string.Join(" ", new[] { errorCode, errorDescription, status }.Where(x => !string.IsNullOrWhiteSpace(x)));
    return string.IsNullOrWhiteSpace(details) ? fallback : $"{fallback} {details}".Trim();
  }

  private static bool TryGetPropertyIgnoreCase(JsonElement element, string name, out JsonElement property)
  {
    if (element.TryGetProperty(name, out property))
    {
      return true;
    }

    foreach (var candidate in element.EnumerateObject())
    {
      if (string.Equals(candidate.Name, name, StringComparison.OrdinalIgnoreCase))
      {
        property = candidate.Value;
        return true;
      }
    }

    property = default;
    return false;
  }

  private static string FirstNonEmpty(params string?[] values)
  {
    return values.FirstOrDefault(value => !string.IsNullOrWhiteSpace(value)) ?? string.Empty;
  }

  private string ResolveDebitAccount(string paymentMode, string? debitAccount)
  {
    return paymentMode == "CASH"
      ? _options.CashDebitGlAccount.Trim()
      : (debitAccount ?? string.Empty).Trim();
  }

  private static string NormalizePaymentMode(string? value)
  {
    return string.Equals((value ?? string.Empty).Trim(), "CASH", StringComparison.OrdinalIgnoreCase)
      ? "CASH"
      : "ACCOUNT";
  }

  private static string NormalizeBranch(string? value, string fallback)
  {
    var branch = (value ?? string.Empty).Trim();
    return branch.Length == 3 && branch.All(char.IsDigit) ? branch : fallback;
  }

  private static string BuildNarrative(RentalPaymentRequest record)
  {
    var details = new List<string>
    {
      $"Bill:{record.BillId}",
      $"Manifest:{record.ManifestId}"
    };

    if (!string.IsNullOrWhiteSpace(record.PropertyName))
    {
      details.Add($"Property:{record.PropertyName}");
    }

    if (record.PenaltyAmount > 0)
    {
      details.Add($"Penalty:{record.PenaltyAmount.ToString("0.##", CultureInfo.InvariantCulture)}");
    }

    if (!string.IsNullOrWhiteSpace(record.Reason))
    {
      details.Add(record.Reason);
    }

    var narrative = $"Rental payment | {string.Join(" | ", details)}";
    return narrative.Length <= 120 ? narrative : narrative[..120];
  }

  private static string BuildPayloadAudit(params (string Label, string Payload)[] sections)
  {
    var builder = new StringBuilder();

    foreach (var section in sections)
    {
      if (string.IsNullOrWhiteSpace(section.Payload))
      {
        continue;
      }

      builder.AppendLine($"===== {section.Label} =====");
      builder.AppendLine(section.Payload.Trim());
      builder.AppendLine();
    }

    return builder.ToString().Trim();
  }
}
