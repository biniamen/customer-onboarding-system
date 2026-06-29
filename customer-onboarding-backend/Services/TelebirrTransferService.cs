using System.Globalization;
using System.Data.Common;
using System.Text;
using System.Text.Json;
using System.Xml.Linq;
using CustomerOnboarding.Backend.Options;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Options;
using Oracle.ManagedDataAccess.Client;

namespace CustomerOnboarding.Backend.Services;

public class TelebirrTransferService(
  HttpClient httpClient,
  IConfiguration configuration,
  IOptions<FcubsOptions> fcubsOptions,
  IOptions<TelebirrOptions> telebirrOptions
) : ITelebirrTransferService
{
  private readonly FcubsOptions _fcubsOptions = fcubsOptions.Value;
  private readonly TelebirrOptions _telebirrOptions = telebirrOptions.Value;
  private readonly string _oracleConnection = configuration.GetConnectionString("OracleDb") ?? string.Empty;

  public decimal MinimumRemainingBalance => _fcubsOptions.MinimumRemainingBalance;
  public string RequiredTransferCurrency => string.IsNullOrWhiteSpace(_fcubsOptions.Currency) ? "ETB" : _fcubsOptions.Currency.Trim().ToUpperInvariant();

  public async Task<TelebirrAccountValidationResult> QueryCustomerAccountAsync(string branchCode, string accountNumber, CancellationToken cancellationToken = default)
  {
    if (string.IsNullOrWhiteSpace(_oracleConnection))
    {
      return new TelebirrAccountValidationResult(
        false,
        "CBS account lookup database connection is not configured.",
        string.Empty,
        accountNumber,
        string.Empty,
        string.Empty,
        string.Empty,
        _fcubsOptions.Currency,
        0m,
        string.Empty,
        string.Empty,
        string.Empty,
        "FAILED",
        string.Empty
      );
    }

    const string sql = """
      SELECT
        BRN,
        ACC,
        CUSTNO,
        CUSTNAME,
        ACCLS,
        CCY,
        AC_STAT_NO_DR,
        AC_STAT_NO_CR,
        AC_STAT_DORMANT,
        AC_STAT_FROZEN,
        TXNSTAT,
        ACY_AVL_BAL
      FROM FCUBS145.CVW_IPS_CUST_ACCOUNT
      WHERE ACC = :p_acc
      """;

    try
    {
      await using var connection = new OracleConnection(_oracleConnection);
      await connection.OpenAsync(cancellationToken);

      await using var command = new OracleCommand(sql, connection)
      {
        BindByName = true
      };
      command.Parameters.Add("p_acc", OracleDbType.Varchar2, accountNumber.Trim(), System.Data.ParameterDirection.Input);

      await using var reader = await command.ExecuteReaderAsync(cancellationToken);
      if (!await reader.ReadAsync(cancellationToken))
      {
        return new TelebirrAccountValidationResult(
          false,
          "Customer account was not found in CBS.",
          string.Empty,
          accountNumber,
          string.Empty,
          string.Empty,
          string.Empty,
          _fcubsOptions.Currency,
          0m,
          string.Empty,
          string.Empty,
          string.Empty,
          "FAILED",
          string.Empty
        );
      }

      var accountData = new
      {
        BRN = SafeReadString(reader, "BRN"),
        ACC = SafeReadString(reader, "ACC"),
        CUSTNO = SafeReadString(reader, "CUSTNO"),
        CUSTNAME = SafeReadString(reader, "CUSTNAME"),
        ACCLS = SafeReadString(reader, "ACCLS"),
        CCY = SafeReadString(reader, "CCY"),
        AC_STAT_NO_DR = SafeReadString(reader, "AC_STAT_NO_DR"),
        AC_STAT_NO_CR = SafeReadString(reader, "AC_STAT_NO_CR"),
        AC_STAT_DORMANT = SafeReadString(reader, "AC_STAT_DORMANT"),
        AC_STAT_FROZEN = SafeReadString(reader, "AC_STAT_FROZEN"),
        TXNSTAT = SafeReadString(reader, "TXNSTAT"),
        ACY_AVL_BAL = SafeReadDecimal(reader, "ACY_AVL_BAL"),
        QueryBranch = branchCode
      };

      var success = !string.IsNullOrWhiteSpace(accountData.CUSTNAME);
      var message = success
        ? "Customer account verified successfully."
        : "CBS account verification failed.";

      return new TelebirrAccountValidationResult(
        success,
        message,
        accountData.BRN,
        accountData.ACC,
        accountData.CUSTNO,
        accountData.CUSTNAME,
        accountData.ACCLS,
        string.IsNullOrWhiteSpace(accountData.CCY) ? _fcubsOptions.Currency : accountData.CCY,
        accountData.ACY_AVL_BAL,
        accountData.AC_STAT_NO_DR,
        accountData.AC_STAT_NO_CR,
        accountData.AC_STAT_FROZEN,
        "SUCCESS",
        JsonSerializer.Serialize(accountData)
      );
    }
    catch (Exception ex)
    {
      return new TelebirrAccountValidationResult(
        false,
        $"CBS account lookup failed. {ex.Message}",
        string.Empty,
        accountNumber,
        string.Empty,
        string.Empty,
        string.Empty,
        _fcubsOptions.Currency,
        0m,
        string.Empty,
        string.Empty,
        string.Empty,
        "FAILED",
        string.Empty
      );
    }
  }

  public async Task<TelebirrAgentValidationResult> QueryAgentAsync(string telebirrShortCode, CancellationToken cancellationToken = default)
  {
    if (string.IsNullOrWhiteSpace(_telebirrOptions.LookupEndpoint))
    {
      return new TelebirrAgentValidationResult(false, "Telebirr agent lookup endpoint is not configured.", telebirrShortCode, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty);
    }

    var payload = BuildAgentLookupPayload(telebirrShortCode);
    using var request = new HttpRequestMessage(HttpMethod.Post, _telebirrOptions.LookupEndpoint);
    request.Content = new StringContent(payload, Encoding.UTF8, "text/xml");

    using var response = await httpClient.SendAsync(request, cancellationToken);
    var raw = await response.Content.ReadAsStringAsync(cancellationToken);

    var resultType = ExtractXmlValue(raw, "ResultType");
    var resultCode = ExtractXmlValue(raw, "ResultCode");
    var resultDesc = ExtractXmlValue(raw, "ResultDesc");
    var organizationName = ExtractXmlValue(raw, "OrganizationName");
    var conversationId = ExtractXmlValue(raw, "ConversationID");

    var success = response.IsSuccessStatusCode &&
                  resultCode == "0" &&
                  !string.IsNullOrWhiteSpace(organizationName);

    var message = success
      ? "Telebirr agent verified successfully."
      : string.IsNullOrWhiteSpace(resultDesc)
        ? "Telebirr agent verification failed."
        : resultDesc;

    return new TelebirrAgentValidationResult(
      success,
      message,
      telebirrShortCode,
      organizationName,
      resultType,
      resultCode,
      resultDesc,
      conversationId,
      raw
    );
  }

  public string? ValidateTransferRules(TelebirrAccountValidationResult accountResult, decimal amount)
  {
    if (!accountResult.Success)
    {
      return accountResult.Message;
    }

    if (amount <= 0)
    {
      return "Transfer amount must be greater than zero.";
    }

    var accountCurrency = (accountResult.Currency ?? string.Empty).Trim().ToUpperInvariant();
    if (!string.Equals(accountCurrency, RequiredTransferCurrency, StringComparison.OrdinalIgnoreCase))
    {
      return $"Only {RequiredTransferCurrency} accounts are allowed for this operation.";
    }

    if (accountResult.NoDebitStatus.Equals("Y", StringComparison.OrdinalIgnoreCase))
    {
      return "The customer account is blocked for debit transactions.";
    }

    if (accountResult.FrozenStatus.Equals("Y", StringComparison.OrdinalIgnoreCase))
    {
      return "The customer account is currently frozen.";
    }

    if (amount > accountResult.AvailableBalance)
    {
      return "The transfer amount is greater than the available balance.";
    }

    var remainingBalance = accountResult.AvailableBalance - amount;
    if (remainingBalance < MinimumRemainingBalance)
    {
      return $"The remaining balance after transfer must stay above {MinimumRemainingBalance:0.##} ETB.";
    }

    return null;
  }

  public async Task<TelebirrTransferProcessingResult> ProcessApprovedTransferAsync(
    string checkerBranchCode,
    string accountBranchCode,
    string checkerUserName,
    string checkerComment,
    int requestId,
    string accountNumber,
    string telebirrShortCode,
    decimal amount,
    string narration,
    CancellationToken cancellationToken = default)
  {
    var accountResult = await QueryCustomerAccountAsync(checkerBranchCode, accountNumber, cancellationToken);
    var postingBranch = ResolvePostingBranchCode(accountBranchCode, accountResult.AccountBranchCode, _fcubsOptions.RtBranch);
    var accountValidationMessage = ValidateTransferRules(accountResult, amount);
    if (!string.IsNullOrWhiteSpace(accountValidationMessage))
    {
      return new TelebirrTransferProcessingResult(
        false,
        accountValidationMessage,
        "VALIDATION_FAILED",
        null,
        accountResult.ResponseStatus,
        accountValidationMessage,
        null,
        null,
        null,
        null,
        null,
        null,
        "VALIDATION_FAILED",
        accountValidationMessage,
        null,
        null,
        null,
        JsonSerializer.Serialize(new { requestId, accountNumber, telebirrShortCode, amount, narration, checkerUserName, checkerComment }),
        accountResult.RawResponse
      );
    }

    var agentResult = await QueryAgentAsync(telebirrShortCode, cancellationToken);
    if (!agentResult.Success)
    {
      return new TelebirrTransferProcessingResult(
        false,
        agentResult.Message,
        "VALIDATION_FAILED",
        null,
        accountResult.ResponseStatus,
        accountResult.Message,
        null,
        null,
        null,
        null,
        agentResult.ConversationId,
        null,
        agentResult.ResultCode,
        agentResult.ResultDesc,
        agentResult.ResultType,
        agentResult.ResultCode,
        agentResult.ResultDesc,
        JsonSerializer.Serialize(new { requestId, accountNumber, telebirrShortCode, amount, narration, checkerUserName, checkerComment }),
        JsonSerializer.Serialize(new { accountLookup = accountResult.RawResponse, agentLookup = agentResult.RawResponse })
      );
    }

    if (string.IsNullOrWhiteSpace(_fcubsOptions.RtEndpoint))
    {
      const string message = "CBS RT posting endpoint is not configured.";
      return new TelebirrTransferProcessingResult(false, message, "CBS_CONFIG_MISSING", null, null, message, null, null, null, null, null, null, "CBS_CONFIG_MISSING", message, null, null, null, string.Empty, string.Empty);
    }

    if (string.IsNullOrWhiteSpace(_telebirrOptions.PaymentEndpoint))
    {
      const string message = "Telebirr payment endpoint is not configured.";
      return new TelebirrTransferProcessingResult(false, message, "TELEBIRR_CONFIG_MISSING", null, null, message, null, null, null, null, null, null, "TELEBIRR_CONFIG_MISSING", message, null, null, null, string.Empty, string.Empty);
    }

    var cbsNarrative = BuildCbsNarrative(telebirrShortCode, requestId);
    var cbsPayload = BuildCbsPostingPayload(postingBranch, accountNumber, amount, cbsNarrative);
    var cbsResult = await SendSoapAsync(_fcubsOptions.RtEndpoint, cbsPayload, cancellationToken);
    var cbsMessageStatus = ExtractXmlValue(cbsResult.RawResponse, "MSGSTAT");
    var cbsReference = FirstNonEmpty(
      ExtractXmlValue(cbsResult.RawResponse, "XREF"),
      ExtractXmlValue(cbsResult.RawResponse, "FCCREF")
    );
    var cbsErrorCode = ExtractXmlValue(cbsResult.RawResponse, "ECODE");
    var cbsErrorDesc = ExtractXmlValue(cbsResult.RawResponse, "EDESC");
    var cbsResponseDesc = BuildServiceMessage("CBS posting failed.", cbsErrorCode, cbsErrorDesc, cbsMessageStatus);

    if (!cbsResult.Success || !string.Equals(cbsMessageStatus, "SUCCESS", StringComparison.OrdinalIgnoreCase) || string.IsNullOrWhiteSpace(cbsReference))
    {
      return new TelebirrTransferProcessingResult(
        false,
        cbsResponseDesc,
        "CBS_POST_FAILED",
        cbsReference,
        cbsMessageStatus,
        cbsResponseDesc,
        null,
        null,
        null,
        null,
        null,
        null,
        "CBS_POST_FAILED",
        cbsResponseDesc,
        null,
        null,
        null,
        cbsPayload,
        cbsResult.RawResponse
      );
    }

    var originatorConversationId = GenerateOriginatorConversationId(postingBranch, requestId);
    var telebirrPaymentPayload = BuildTelebirrPaymentPayload(originatorConversationId, telebirrShortCode, amount, cbsReference);
    var telebirrResult = await SendSoapAsync(_telebirrOptions.PaymentEndpoint, telebirrPaymentPayload, cancellationToken);
    var resultType = ExtractXmlValue(telebirrResult.RawResponse, "ResultType");
    var resultCode = ExtractXmlValue(telebirrResult.RawResponse, "ResultCode");
    var resultDesc = ExtractXmlValue(telebirrResult.RawResponse, "ResultDesc");
    var transactionId = ExtractXmlValue(telebirrResult.RawResponse, "TransactionID");
    var conversationId = ExtractXmlValue(telebirrResult.RawResponse, "ConversationID");
    var responseOriginatorId = ExtractXmlValue(telebirrResult.RawResponse, "OriginatorConversationID");

    var telebirrSuccess = telebirrResult.Success &&
                          string.Equals(resultCode, "0", StringComparison.OrdinalIgnoreCase) &&
                          !string.IsNullOrWhiteSpace(transactionId);

    if (telebirrSuccess)
    {
      return new TelebirrTransferProcessingResult(
        true,
        "Transfer posted successfully in CBS and Telebirr.",
        "APPROVED",
        cbsReference,
        cbsMessageStatus,
        "CBS posting successful.",
        null,
        null,
        null,
        transactionId,
        conversationId,
        string.IsNullOrWhiteSpace(responseOriginatorId) ? originatorConversationId : responseOriginatorId,
        resultCode,
        resultDesc,
        resultType,
        resultCode,
        resultDesc,
        BuildPayloadAudit(
          ("CBS_POSTING", cbsPayload),
          ("TELEBIRR_PAYMENT", telebirrPaymentPayload)
        ),
        BuildPayloadAudit(
          ("CBS_RESPONSE", cbsResult.RawResponse),
          ("TELEBIRR_RESPONSE", telebirrResult.RawResponse)
        )
      );
    }

    var reversalPayload = BuildCbsReversalPayload(postingBranch, cbsReference);
    var reversalResult = await SendSoapAsync(_fcubsOptions.RtEndpoint, reversalPayload, cancellationToken);
    var reversalStatus = ExtractXmlValue(reversalResult.RawResponse, "MSGSTAT");
    var reversalReference = FirstNonEmpty(
      ExtractXmlValue(reversalResult.RawResponse, "XREF"),
      ExtractXmlValue(reversalResult.RawResponse, "FCCREF"),
      cbsReference
    );
    var reversalResponseDesc = BuildServiceMessage(
      "CBS reversal failed.",
      ExtractXmlValue(reversalResult.RawResponse, "ECODE"),
      ExtractXmlValue(reversalResult.RawResponse, "EDESC"),
      reversalStatus
    );
    var reversalSuccess = reversalResult.Success && string.Equals(reversalStatus, "SUCCESS", StringComparison.OrdinalIgnoreCase);

    var finalServiceStatus = reversalSuccess
      ? "TELEBIRR_FAILED_REVERSED"
      : "TELEBIRR_FAILED_REVERSAL_FAILED";

    var telebirrFailureMessage = string.IsNullOrWhiteSpace(resultDesc)
      ? "Telebirr payment failed after CBS posting."
      : resultDesc;

    var finalMessage = reversalSuccess
      ? $"{telebirrFailureMessage} CBS transaction was reversed successfully."
      : $"{telebirrFailureMessage} CBS reversal failed and needs manual follow-up.";

    var exactTelebirrDesc = FirstNonEmpty(resultDesc, telebirrFailureMessage);

    return new TelebirrTransferProcessingResult(
      false,
      finalMessage,
      finalServiceStatus,
      cbsReference,
      cbsMessageStatus,
      "CBS posting successful.",
      reversalReference,
      reversalStatus,
      reversalResponseDesc,
      transactionId,
      conversationId,
      string.IsNullOrWhiteSpace(responseOriginatorId) ? originatorConversationId : responseOriginatorId,
      resultCode,
      exactTelebirrDesc,
      resultType,
      resultCode,
      resultDesc,
      BuildPayloadAudit(
        ("CBS_POSTING", cbsPayload),
        ("TELEBIRR_PAYMENT", telebirrPaymentPayload),
        ("CBS_REVERSAL", reversalPayload)
      ),
      BuildPayloadAudit(
        ("CBS_RESPONSE", cbsResult.RawResponse),
        ("TELEBIRR_RESPONSE", telebirrResult.RawResponse),
        ("CBS_REVERSAL_RESPONSE", reversalResult.RawResponse)
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

  private string BuildCbsPostingPayload(string branchCode, string accountNumber, decimal amount, string narration)
  {
    var transactionDate = DateTime.UtcNow.ToString("yyyy-MM-dd");
    var txnBranch = NormalizeBranch(branchCode, _fcubsOptions.RtBranch);
    var offsetBranch = NormalizeBranch(_fcubsOptions.RtOffsetBranch, txnBranch);

    return $@"<?xml version=""1.0"" encoding=""UTF-8""?>
<soapenv:Envelope xmlns:soapenv=""http://schemas.xmlsoap.org/soap/envelope/"" xmlns:fcub=""http://fcubs.ofss.com/service/FCUBSRTService"">
   <soapenv:Header/>
   <soapenv:Body>
      <fcub:CREATETRANSACTION_FSFS_REQ>
         <fcub:FCUBS_HEADER>
            <fcub:SOURCE>{EscapeXml(_fcubsOptions.RtSource)}</fcub:SOURCE>
            <fcub:UBSCOMP>{EscapeXml(_fcubsOptions.UbsComp)}</fcub:UBSCOMP>
            <fcub:USERID>{EscapeXml(_fcubsOptions.RtUserId)}</fcub:USERID>
            <fcub:BRANCH>{EscapeXml(txnBranch)}</fcub:BRANCH>
            <fcub:SERVICE>{EscapeXml(_fcubsOptions.RtService)}</fcub:SERVICE>
            <fcub:OPERATION>{EscapeXml(_fcubsOptions.RtOperation)}</fcub:OPERATION>
         </fcub:FCUBS_HEADER>
         <fcub:FCUBS_BODY>
            <fcub:Transaction-Details>
               <fcub:PRD>{EscapeXml(_fcubsOptions.RtProductCode)}</fcub:PRD>
               <fcub:BRN>{EscapeXml(txnBranch)}</fcub:BRN>
               <fcub:TXNBRN>{EscapeXml(txnBranch)}</fcub:TXNBRN>
               <fcub:TXNACC>{EscapeXml(accountNumber)}</fcub:TXNACC>
               <fcub:TXNCCY>{EscapeXml(_fcubsOptions.RtCurrency)}</fcub:TXNCCY>
               <fcub:TXNAMT>{amount.ToString("0.##", CultureInfo.InvariantCulture)}</fcub:TXNAMT>
               <fcub:OFFSETBRN>{EscapeXml(offsetBranch)}</fcub:OFFSETBRN>
               <fcub:OFFSETACC>{EscapeXml(_fcubsOptions.RtOffsetAccount)}</fcub:OFFSETACC>
               <fcub:OFFSETCCY>{EscapeXml(_fcubsOptions.RtCurrency)}</fcub:OFFSETCCY>
               <fcub:TXNDATE>{transactionDate}</fcub:TXNDATE>
               <fcub:VALDATE>{transactionDate}</fcub:VALDATE>
               <fcub:NARRATIVE>{EscapeXml(string.IsNullOrWhiteSpace(narration) ? "Telebirr transfer" : narration)}</fcub:NARRATIVE>
            </fcub:Transaction-Details>
         </fcub:FCUBS_BODY>
      </fcub:CREATETRANSACTION_FSFS_REQ>
   </soapenv:Body>
</soapenv:Envelope>";
  }

  private string BuildCbsReversalPayload(string branchCode, string cbsReference)
  {
    var reversalBranch = NormalizeBranch(branchCode, _fcubsOptions.RtBranch);
    var reversalProduct = string.IsNullOrWhiteSpace(_fcubsOptions.RtReversalProductCode)
      ? _fcubsOptions.RtProductCode
      : _fcubsOptions.RtReversalProductCode;

    return $@"<?xml version=""1.0"" encoding=""UTF-8""?>
<soapenv:Envelope xmlns:soapenv=""http://schemas.xmlsoap.org/soap/envelope/"" xmlns:fcub=""http://fcubs.ofss.com/service/FCUBSRTService"">
   <soapenv:Header/>
   <soapenv:Body>
      <fcub:REVERSETRANSACTION_FSFS_REQ>
         <fcub:FCUBS_HEADER>
            <fcub:SOURCE>{EscapeXml(_fcubsOptions.RtReversalSource)}</fcub:SOURCE>
            <fcub:UBSCOMP>{EscapeXml(_fcubsOptions.UbsComp)}</fcub:UBSCOMP>
            <fcub:USERID>{EscapeXml(_fcubsOptions.RtReversalUserId)}</fcub:USERID>
            <fcub:BRANCH>{EscapeXml(reversalBranch)}</fcub:BRANCH>
            <fcub:SERVICE>{EscapeXml(_fcubsOptions.RtReversalService)}</fcub:SERVICE>
            <fcub:OPERATION>{EscapeXml(_fcubsOptions.RtReversalOperation)}</fcub:OPERATION>
         </fcub:FCUBS_HEADER>
         <fcub:FCUBS_BODY>
            <fcub:Transaction-Details>
               <fcub:XREF>{EscapeXml(cbsReference)}</fcub:XREF>
               <fcub:FCCREF>{EscapeXml(cbsReference)}</fcub:FCCREF>
               <fcub:PRD>{EscapeXml(reversalProduct)}</fcub:PRD>
               <fcub:BRN>{EscapeXml(reversalBranch)}</fcub:BRN>
               <fcub:MODULE>{EscapeXml(_fcubsOptions.RtReversalModule)}</fcub:MODULE>
            </fcub:Transaction-Details>
         </fcub:FCUBS_BODY>
      </fcub:REVERSETRANSACTION_FSFS_REQ>
   </soapenv:Body>
</soapenv:Envelope>";
  }

  private string BuildAgentLookupPayload(string telebirrShortCode)
  {
    var timestamp = DateTime.UtcNow.ToString("yyyyMMddHHmmss");
    return $@"<?xml version=""1.0"" encoding=""UTF-8""?>
<soapenv:Envelope xmlns:soapenv=""http://schemas.xmlsoap.org/soap/envelope/"" xmlns:api=""http://cps.huawei.com/synccpsinterface/api_requestmgr"" xmlns:req=""http://cps.huawei.com/synccpsinterface/request"" xmlns:com=""http://cps.huawei.com/synccpsinterface/common"">
  <soapenv:Header/>
  <soapenv:Body>
    <api:Request>
      <req:Header>
        <req:Version>{EscapeXml(_telebirrOptions.Version)}</req:Version>
        <req:CommandID>{EscapeXml(_telebirrOptions.LookupCommandId)}</req:CommandID>
        <req:Caller>
          <req:CallerType>{_telebirrOptions.LookupCallerType}</req:CallerType>
          <req:ThirdPartyID>{EscapeXml(_telebirrOptions.LookupThirdPartyId)}</req:ThirdPartyID>
          <req:Password>{EscapeXml(_telebirrOptions.LookupCallerPassword)}</req:Password>
        </req:Caller>
        <req:KeyOwner>{_telebirrOptions.KeyOwner}</req:KeyOwner>
        <req:Timestamp>{timestamp}</req:Timestamp>
      </req:Header>
      <req:Body>
        <req:Identity>
          <req:Initiator>
            <req:IdentifierType>{_telebirrOptions.LookupInitiatorIdentifierType}</req:IdentifierType>
            <req:Identifier>{EscapeXml(_telebirrOptions.LookupInitiatorIdentifier)}</req:Identifier>
            <req:SecurityCredential>{EscapeXml(_telebirrOptions.LookupInitiatorSecurityCredential)}</req:SecurityCredential>
          </req:Initiator>
          <req:ReceiverParty>
            <req:IdentifierType>{_telebirrOptions.LookupReceiverIdentifierType}</req:IdentifierType>
            <req:Identifier>{EscapeXml(telebirrShortCode)}</req:Identifier>
          </req:ReceiverParty>
        </req:Identity>
        <req:QueryOrganizationInfoRequest/>
        <req:Remark>{EscapeXml(_telebirrOptions.LookupRemark)}</req:Remark>
      </req:Body>
    </api:Request>
  </soapenv:Body>
</soapenv:Envelope>";
  }

  private string BuildTelebirrPaymentPayload(string originatorConversationId, string telebirrShortCode, decimal amount, string cbsReference)
  {
    var timestamp = DateTime.UtcNow.ToString("yyyyMMddHHmmss");
    var resultUrlSection = string.IsNullOrWhiteSpace(_telebirrOptions.PaymentResultUrl)
      ? string.Empty
      : $@"
          <req:ResultURL>{EscapeXml(_telebirrOptions.PaymentResultUrl)}</req:ResultURL>";
    return $@"<?xml version=""1.0"" encoding=""UTF-8""?>
<soapenv:Envelope xmlns:soapenv=""http://schemas.xmlsoap.org/soap/envelope/"" xmlns:api=""http://cps.huawei.com/synccpsinterface/api_requestmgr"" xmlns:req=""http://cps.huawei.com/synccpsinterface/request"" xmlns:com=""http://cps.huawei.com/synccpsinterface/common"">
  <soapenv:Header/>
  <soapenv:Body>
    <api:Request>
      <req:Header>
        <req:Version>{EscapeXml(_telebirrOptions.Version)}</req:Version>
        <req:CommandID>{EscapeXml(_telebirrOptions.PaymentCommandId)}</req:CommandID>
        <req:OriginatorConversationID>{EscapeXml(originatorConversationId)}</req:OriginatorConversationID>
        <req:Caller>
          <req:CallerType>{_telebirrOptions.PaymentCallerType}</req:CallerType>
          <req:ThirdPartyID>{EscapeXml(_telebirrOptions.PaymentThirdPartyId)}</req:ThirdPartyID>
          <req:Password>{EscapeXml(_telebirrOptions.PaymentCallerPassword)}</req:Password>
{resultUrlSection}
        </req:Caller>
        <req:KeyOwner>{_telebirrOptions.KeyOwner}</req:KeyOwner>
        <req:Timestamp>{timestamp}</req:Timestamp>
      </req:Header>
      <req:Body>
        <req:Identity>
          <req:Initiator>
            <req:IdentifierType>{_telebirrOptions.PaymentInitiatorIdentifierType}</req:IdentifierType>
            <req:Identifier>{EscapeXml(_telebirrOptions.PaymentInitiatorIdentifier)}</req:Identifier>
            <req:SecurityCredential>{EscapeXml(_telebirrOptions.PaymentInitiatorSecurityCredential)}</req:SecurityCredential>
            <req:ShortCode>{EscapeXml(_telebirrOptions.PaymentInitiatorShortCode)}</req:ShortCode>
          </req:Initiator>
          <req:ReceiverParty>
            <req:IdentifierType>{_telebirrOptions.PaymentReceiverIdentifierType}</req:IdentifierType>
            <req:Identifier>{EscapeXml(telebirrShortCode)}</req:Identifier>
          </req:ReceiverParty>
        </req:Identity>
        <req:TransactionRequest>
          <req:Parameters>
            <req:Amount>{amount.ToString("0.##", CultureInfo.InvariantCulture)}</req:Amount>
            <req:Currency>{EscapeXml(_telebirrOptions.PaymentCurrency)}</req:Currency>
          </req:Parameters>
        </req:TransactionRequest>
        <req:Remark>{EscapeXml(cbsReference)}</req:Remark>
      </req:Body>
    </api:Request>
  </soapenv:Body>
</soapenv:Envelope>";
  }

  private string GenerateOriginatorConversationId(string branchCode, int requestId)
  {
    var normalizedBranch = NormalizeBranch(branchCode, "000");
    var suffix = DateTime.UtcNow.ToString("yyMMddHHmmss", CultureInfo.InvariantCulture);
    return $"{normalizedBranch}{_telebirrOptions.PaymentRemarkPrefix}{suffix}{requestId:D4}";
  }

  private static string NormalizeBranch(string? value, string fallback)
  {
    var branch = (value ?? string.Empty).Trim();
    if (branch.Length == 3 && branch.All(char.IsDigit))
    {
      return branch;
    }

    return fallback;
  }

  private static string BuildServiceMessage(string fallback, string errorCode, string errorMessage, string responseStatus)
  {
    var details = string.Join(" ", new[] { errorCode, errorMessage, responseStatus }.Where(x => !string.IsNullOrWhiteSpace(x)));
    return string.IsNullOrWhiteSpace(details) ? fallback : $"{fallback} {details}".Trim();
  }

  private static string BuildCbsNarrative(string telebirrShortCode, int requestId)
  {
    var shortCode = (telebirrShortCode ?? string.Empty).Trim();
    var reference = $"REF{requestId}";
    var narrative = $"{shortCode}-{reference}".Trim('-');
    return narrative.Length <= 80 ? narrative : narrative[..80];
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

  private static string SafeReadString(DbDataReader reader, string column)
  {
    var value = reader[column];
    return value == DBNull.Value ? string.Empty : value?.ToString()?.Trim() ?? string.Empty;
  }

  private static decimal SafeReadDecimal(DbDataReader reader, string column)
  {
    var value = reader[column];
    if (value == DBNull.Value || value is null)
    {
      return 0m;
    }

    return decimal.TryParse(value.ToString(), NumberStyles.Any, CultureInfo.InvariantCulture, out var parsed)
      ? parsed
      : 0m;
  }

  private static string FirstNonEmpty(params string[] values)
  {
    return values.FirstOrDefault(value => !string.IsNullOrWhiteSpace(value)) ?? string.Empty;
  }

  private static string BuildPayloadAudit(params (string Label, string Payload)[] sections)
  {
    var lines = new List<string>();
    foreach (var section in sections)
    {
      if (string.IsNullOrWhiteSpace(section.Payload))
      {
        continue;
      }

      lines.Add($"===== {section.Label} =====");
      lines.Add(section.Payload.Trim());
      lines.Add(string.Empty);
    }

    return string.Join(Environment.NewLine, lines).Trim();
  }

  private static string ResolvePostingBranchCode(string accountBranchCode, string lookupBranchCode, string fallbackBranchCode)
  {
    var direct = NormalizeBranch(accountBranchCode, string.Empty);
    if (!string.IsNullOrWhiteSpace(direct))
    {
      return direct;
    }

    var lookup = NormalizeBranch(lookupBranchCode, string.Empty);
    if (!string.IsNullOrWhiteSpace(lookup))
    {
      return lookup;
    }

    return NormalizeBranch(fallbackBranchCode, "000");
  }
}
