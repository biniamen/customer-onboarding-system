using System.Text;
using System.Text.Json;
using System.Globalization;
using System.Xml.Linq;
using CustomerOnboarding.Backend.Dtos;
using CustomerOnboarding.Backend.Models;
using CustomerOnboarding.Backend.Options;
using Microsoft.Extensions.Options;

namespace CustomerOnboarding.Backend.Services;

public record OnboardingFulfillmentResult(
  bool Success,
  bool IsDuplicateCif,
  string Message,
  string CustomerNumber,
  string AccountNumber,
  string CifResponse,
  string UploadResponse,
  string AccountResponse
);

public interface IOnboardingFulfillmentService
{
  Task<OnboardingFulfillmentResult> FulfillAsync(OnboardingRecord record, CancellationToken cancellationToken = default);
}

public class OnboardingFulfillmentService(
  HttpClient httpClient,
  IOptions<FcubsOptions> fcubsOptions,
  IAccountApprovalService accountApprovalService) : IOnboardingFulfillmentService
{
  private static readonly JsonSerializerOptions JsonOptions = new()
  {
    PropertyNameCaseInsensitive = true,
    PropertyNamingPolicy = JsonNamingPolicy.CamelCase
  };
  private readonly FcubsOptions _fcubsOptions = fcubsOptions.Value;

  public async Task<OnboardingFulfillmentResult> FulfillAsync(OnboardingRecord record, CancellationToken cancellationToken = default)
  {
    var snapshot = Deserialize<CustomerSnapshotDto>(record.SnapshotJson);
    var details = Deserialize<AdditionalDetailsDto>(record.AdditionalDetailsJson);
    var accountDetails = Deserialize<AccountDetailsDto>(record.AccountDetailsJson);
    if (snapshot is null || details is null || accountDetails is null)
    {
      return Failed("Saved onboarding data is incomplete. The request cannot be sent to FCUBS.");
    }

    var customerNumber = IsTemporaryReference(record.CustomerNumber) ? string.Empty : record.CustomerNumber;
    var cifResponse = record.CifResponseJson;
    if (string.IsNullOrWhiteSpace(customerNumber))
    {
      if (string.IsNullOrWhiteSpace(_fcubsOptions.CustomerEndpoint))
      {
        return Failed("FCUBS customer endpoint is not configured.");
      }

      var cifPayload = BuildCifPayload(record, snapshot, details);
      using var cifRequest = new HttpRequestMessage(HttpMethod.Post, _fcubsOptions.CustomerEndpoint)
      {
        Content = new StringContent(cifPayload, Encoding.UTF8, "text/xml")
      };
      using var cifHttpResponse = await httpClient.SendAsync(cifRequest, cancellationToken);
      cifResponse = await cifHttpResponse.Content.ReadAsStringAsync(cancellationToken);
      var cifErrorCode = ExtractXmlValue(cifResponse, "ECODE");
      var cifErrorDescription = ExtractXmlValue(cifResponse, "EDESC");
      var cifErrors = ExtractFcubsErrors(cifResponse);
      if (string.Equals(cifErrorCode, "ST-CIF24", StringComparison.OrdinalIgnoreCase))
      {
        return new OnboardingFulfillmentResult(false, true,
          $"FCUBS duplicate CIF control blocked this request: {cifErrorDescription}", string.Empty, string.Empty,
          cifResponse, string.Empty, string.Empty);
      }

      customerNumber = ExtractXmlValue(cifResponse, "CUSTNO");
      var cifStatus = ExtractXmlValue(cifResponse, "MSGSTAT");
      if (!cifHttpResponse.IsSuccessStatusCode || !string.Equals(cifStatus, "SUCCESS", StringComparison.OrdinalIgnoreCase) || string.IsNullOrWhiteSpace(customerNumber))
      {
        var reason = !string.IsNullOrWhiteSpace(cifErrors)
          ? cifErrors
          : string.IsNullOrWhiteSpace(cifErrorDescription)
          ? "FCUBS did not return a customer number."
          : $"{cifErrorCode}: {cifErrorDescription}".Trim(':', ' ');
        return new OnboardingFulfillmentResult(false, false, $"CIF creation failed. {reason}", string.Empty, string.Empty,
          cifResponse, string.Empty, string.Empty);
      }
    }

    if (string.IsNullOrWhiteSpace(_fcubsOptions.CustomerImageSignatureEndpoint))
    {
      return new OnboardingFulfillmentResult(false, false, "Customer image and signature endpoint is not configured.", customerNumber, string.Empty,
        cifResponse, string.Empty, string.Empty);
    }

    var uploadPayload = BuildAssetPayload(record.BranchCode, customerNumber, accountDetails);
    using var uploadRequest = new HttpRequestMessage(HttpMethod.Post, _fcubsOptions.CustomerImageSignatureEndpoint)
    {
      Content = new StringContent(JsonSerializer.Serialize(uploadPayload, JsonOptions), Encoding.UTF8, "application/json")
    };
    using var uploadHttpResponse = await httpClient.SendAsync(uploadRequest, cancellationToken);
    var uploadResponse = await uploadHttpResponse.Content.ReadAsStringAsync(cancellationToken);
    if (!uploadHttpResponse.IsSuccessStatusCode || IndicatesFailure(uploadResponse))
    {
      return new OnboardingFulfillmentResult(false, false, "Customer image and signature upload failed.", customerNumber, string.Empty,
        cifResponse, uploadResponse, string.Empty);
    }

    record.CustomerNumber = customerNumber;
    var accountResult = await accountApprovalService.CreateAccountAsync(record, cancellationToken);
    if (!accountResult.Success)
    {
      return new OnboardingFulfillmentResult(false, false, accountResult.Message, customerNumber, accountResult.AccountNumber,
        cifResponse, uploadResponse, accountResult.RawResponse);
    }

    return new OnboardingFulfillmentResult(true, false, accountResult.Message, customerNumber, accountResult.AccountNumber,
      cifResponse, uploadResponse, accountResult.RawResponse);
  }

  private string BuildCifPayload(OnboardingRecord record, CustomerSnapshotDto snapshot, AdditionalDetailsDto details)
  {
    var today = DateTime.UtcNow.ToString("yyyy-MM-dd");
    var monthlyIncome = details.MonthlyIncome is > 0 ? details.MonthlyIncome.Value : 0m;
    var annualIncome = monthlyIncome > 0 ? monthlyIncome * 12 : 0m;
    var guardian = snapshot.Minor ? (details.GuardianName ?? details.MotherName) : string.Empty;
    var category = snapshot.Minor ? _fcubsOptions.MinorCustomerCategory : _fcubsOptions.CustomerCategory;
    var mobile = NormalizeMobile(details.MobileNumber);
    var registrationStatus = details.IsSoleProprietor ? "YES" : "NO";

    return $@"<?xml version=""1.0"" encoding=""utf-8""?>
<soapenv:Envelope xmlns:soapenv=""http://schemas.xmlsoap.org/soap/envelope/"" xmlns:fcub=""http://fcubs.ofss.com/service/FCUBSCustomerService"">
  <soapenv:Header/>
  <soapenv:Body>
    <fcub:CREATECUSTOMER_FSFS_REQ>
      <fcub:FCUBS_HEADER>
        <fcub:SOURCE>{EscapeXml(_fcubsOptions.Source)}</fcub:SOURCE>
        <fcub:UBSCOMP>{EscapeXml(_fcubsOptions.UbsComp)}</fcub:UBSCOMP>
        <fcub:USERID>{EscapeXml(_fcubsOptions.UserId)}</fcub:USERID>
        <fcub:BRANCH>{EscapeXml(record.BranchCode)}</fcub:BRANCH>
        <fcub:SERVICE>FCUBSCustomerService</fcub:SERVICE>
        <fcub:OPERATION>CreateCustomer</fcub:OPERATION>
      </fcub:FCUBS_HEADER>
      <fcub:FCUBS_BODY>
        <fcub:Customer-Full>
          <fcub:CUSTNO/>
          <fcub:CTYPE>I</fcub:CTYPE>
          <fcub:ADDRLN1>{EscapeXml(snapshot.AddressLine1)}</fcub:ADDRLN1>
          <fcub:ADDRLN2>{EscapeXml(snapshot.AddressLine2)}</fcub:ADDRLN2>
          <fcub:ADDRLN3>{EscapeXml(snapshot.AddressLine3)}</fcub:ADDRLN3>
          <fcub:ADDRLN4>{EscapeXml(snapshot.AddressLine4)}</fcub:ADDRLN4>
          <fcub:COUNTRY>{EscapeXml(snapshot.Country)}</fcub:COUNTRY>
          <fcub:SNAME>{EscapeXml(BuildShortName(snapshot))}</fcub:SNAME>
          <fcub:NLTY>{EscapeXml(snapshot.Nationality)}</fcub:NLTY>
          <fcub:LBRN>{EscapeXml(record.BranchCode)}</fcub:LBRN>
          <fcub:CCATEG>{EscapeXml(category)}</fcub:CCATEG>
          <fcub:FULLNAME>{EscapeXml(snapshot.FullName)}</fcub:FULLNAME>
          <fcub:UIDNAME>NATIONAL ID</fcub:UIDNAME>
          <fcub:UIDVAL>{EscapeXml(snapshot.NationalId)}</fcub:UIDVAL>
          <fcub:MEDIA>{EscapeXml(_fcubsOptions.Media)}</fcub:MEDIA>
          <fcub:LOC>{EscapeXml(snapshot.RegionCode)}</fcub:LOC>
          <fcub:CREATEACC>N</fcub:CREATEACC>
          <fcub:TRACK_LIMITS>Y</fcub:TRACK_LIMITS>
          <fcub:Custpersonal>
            <fcub:FSTNAME>{EscapeXml(snapshot.FirstName)}</fcub:FSTNAME>
            <fcub:MIDNAME>{EscapeXml(snapshot.MiddleName)}</fcub:MIDNAME>
            <fcub:LSTNAME>{EscapeXml(snapshot.LastName)}</fcub:LSTNAME>
            <fcub:DOB>{EscapeXml(snapshot.DateOfBirth)}</fcub:DOB>
            <fcub:GENDR>{EscapeXml(snapshot.Gender)}</fcub:GENDR>
            <fcub:NATIONID>{EscapeXml(snapshot.NationalId)}</fcub:NATIONID>
            <fcub:MOBNUM>{EscapeXml(mobile)}</fcub:MOBNUM>
            <fcub:LANG>ENG</fcub:LANG>
            <fcub:GUARDIAN>{EscapeXml(guardian)}</fcub:GUARDIAN>
            <fcub:SBMTAGEPROOF>{(snapshot.Minor ? "P" : "N")}</fcub:SBMTAGEPROOF>
            <fcub:MINOR>{(snapshot.Minor ? "Y" : "N")}</fcub:MINOR>
            <fcub:KYCSTAT>N</fcub:KYCSTAT>
            <fcub:TITLE>{EscapeXml(details.Title)}</fcub:TITLE>
            <fcub:PLACEOFBIRTH>{EscapeXml(details.PlaceOfBirth)}</fcub:PLACEOFBIRTH>
            <fcub:BIRTHCOUNTRY>{EscapeXml(snapshot.Country)}</fcub:BIRTHCOUNTRY>
            <fcub:MOBISDNO>251</fcub:MOBISDNO>
            <fcub:MOTHERMAIDN_NAME>{EscapeXml(details.MotherName)}</fcub:MOTHERMAIDN_NAME>
            <fcub:Custdomestic><fcub:MARITALSTAT>{EscapeXml(details.MaritalStatus)}</fcub:MARITALSTAT></fcub:Custdomestic>
            <fcub:Custprof><fcub:EMPSTAT>U</fcub:EMPSTAT><fcub:AMTCCY1>ETB</fcub:AMTCCY1></fcub:Custprof>
          </fcub:Custpersonal>
          <fcub:Custdoc-Chklist><fcub:DOCCATEGORY>KEBELE_ID</fcub:DOCCATEGORY><fcub:DOCUMENTNAME>KEBELE/WOREDA ID CARD NUMBER IF GIVEN BY REGION OF RESIDENCE</fcub:DOCUMENTNAME><fcub:DOCUMENT_TYPE>KEBELE_ID</fcub:DOCUMENT_TYPE><fcub:CHECKED>Y</fcub:CHECKED><fcub:DATEREQ>{today}</fcub:DATEREQ><fcub:ACTUALDATE>{today}</fcub:ACTUALDATE><fcub:EXPDATE>{today}</fcub:EXPDATE></fcub:Custdoc-Chklist>
          {Udf("TIN_STATUS", string.IsNullOrWhiteSpace(details.TinNumber) ? "NO" : "YES")}
          {Udf("TAX_IDENTIFICATION_NUMBER", details.TinNumber)}
          {Udf("AVERAGE_MONTHLY_INCOME", monthlyIncome > 0 ? monthlyIncome.ToString("0.##", CultureInfo.InvariantCulture) : string.Empty)}
          {Udf("AVERAGE_ANNUAL_INCOME", annualIncome > 0 ? annualIncome.ToString("0.##", CultureInfo.InvariantCulture) : string.Empty)}
          {Udf("OCCUPATION", details.Occupation)}
          {Udf("WORK_POSITION", details.WorkPosition)}
          {Udf("EMPLOYER", details.Employer)}
          {Udf("STAFF_STATUS", details.StaffStatus)}
          {Udf("REGISTRATION_STATUS", registrationStatus)}
          {Udf("REGISTRATION_NUMBER", details.BusinessRegistrationNumber)}
          {Udf("TRADE_LICENSE_NUMBER", details.BusinessLicenseNumber)}
          {Udf("DISTRICT", snapshot.WoredaName)}
          {Udf("MOTHER NAME", details.MotherName)}
          {Udf("ID_ISSUED_BY", "GOVERNMENT")}
          {Udf("ID_TYPE", details.IdType)}
          {Udf("RISK_PROFILE", "Low")}
          {Udf("SOURCE OF CUSTOMER", "BRANCH")}
        </fcub:Customer-Full>
      </fcub:FCUBS_BODY>
    </fcub:CREATECUSTOMER_FSFS_REQ>
  </soapenv:Body>
</soapenv:Envelope>";
  }

  private object BuildAssetPayload(string branchCode, string customerNumber, AccountDetailsDto details)
  {
    var generatedSeq = DateTimeOffset.UtcNow.ToUnixTimeMilliseconds().ToString()[^7..];
    var signatureName = $"{customerNumber}_signature.{details.SignatureFileType.ToLowerInvariant()}";
    var imageName = string.IsNullOrWhiteSpace(details.ImageFileName)
      ? $"{customerNumber}_{customerNumber}img.{details.ImageFileType.ToLowerInvariant()}"
      : details.ImageFileName;
    return new
    {
      customerNo = customerNumber,
      cifSigId = customerNumber,
      branchCode,
      signatureBase64 = details.SignatureBase64,
      signatureFileType = details.SignatureFileType,
      signatureSpecimenNo = 1,
      signatureSpecimenSeqNo = generatedSeq,
      signatureRecordStat = "N",
      signatureStatus = "N",
      imageBase64 = details.ImageBase64,
      imageFileName = imageName,
      imageSeqNo = 1,
      imageSpecimenSeqNo = generatedSeq,
      imageStatus = "N",
      imgMasterRecordStat = "O",
      imgMasterAuthStat = "A",
      makerId = _fcubsOptions.UserId,
      checkerId = _fcubsOptions.UserId,
      modNo = 1,
      onceAuth = "Y",
      functionId = "STDCIFIS",
      tableName = "STTM_CUST_IMG_MASTER",
      recordLogRecordStat = "O",
      recordLogAuthStat = "A",
      cifSigName = signatureName,
      cifSigTitle = signatureName,
      sigMasterRecordStat = "O",
      sigMasterAuthStat = "A",
      sigMasterOnceAuth = "Y",
      replToAcc = "Y"
    };
  }

  private static OnboardingFulfillmentResult Failed(string message) => new(false, false, message, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty);

  private static bool IsTemporaryReference(string value) => string.IsNullOrWhiteSpace(value) || value.StartsWith("TMP-", StringComparison.OrdinalIgnoreCase);

  private static bool IndicatesFailure(string response)
  {
    try
    {
      using var document = JsonDocument.Parse(response);
      var successProperty = document.RootElement
        .EnumerateObject()
        .FirstOrDefault(property => string.Equals(property.Name, "success", StringComparison.OrdinalIgnoreCase));
      return successProperty.Value.ValueKind == JsonValueKind.False;
    }
    catch (JsonException)
    {
      return false;
    }
  }

  private static T? Deserialize<T>(string json)
  {
    try { return JsonSerializer.Deserialize<T>(json, JsonOptions); }
    catch (JsonException) { return default; }
  }

  private static string ExtractXmlValue(string xml, string localName)
  {
    try { return XDocument.Parse(xml).Descendants().FirstOrDefault(element => element.Name.LocalName == localName)?.Value?.Trim() ?? string.Empty; }
    catch { return string.Empty; }
  }

  private static string ExtractFcubsErrors(string xml)
  {
    try
    {
      var errors = XDocument.Parse(xml)
        .Descendants()
        .Where(element => element.Name.LocalName == "ERROR")
        .Select(error => new
        {
          Code = error.Elements().FirstOrDefault(element => element.Name.LocalName == "ECODE")?.Value?.Trim(),
          Description = error.Elements().FirstOrDefault(element => element.Name.LocalName == "EDESC")?.Value?.Trim()
        })
        .Where(error => !string.IsNullOrWhiteSpace(error.Code) || !string.IsNullOrWhiteSpace(error.Description))
        .Select(error => string.IsNullOrWhiteSpace(error.Code)
          ? error.Description!
          : string.IsNullOrWhiteSpace(error.Description)
            ? error.Code
            : $"{error.Code}: {error.Description}")
        .Distinct(StringComparer.OrdinalIgnoreCase);

      return string.Join(" | ", errors);
    }
    catch
    {
      return string.Empty;
    }
  }

  private static string BuildShortName(CustomerSnapshotDto snapshot) => string.Join(" ", new[] { snapshot.FirstName, snapshot.LastName }.Where(value => !string.IsNullOrWhiteSpace(value)));

  private static string NormalizeMobile(string value) => (value ?? string.Empty).Trim().Replace("+251", "0", StringComparison.Ordinal).Replace("251", "0", StringComparison.Ordinal);

  private static string Udf(string name, string? value) => string.IsNullOrWhiteSpace(value)
    ? $"<fcub:UDFDETAILS><fcub:FLDNAM>{EscapeXml(name)}</fcub:FLDNAM></fcub:UDFDETAILS>"
    : $"<fcub:UDFDETAILS><fcub:FLDNAM>{EscapeXml(name)}</fcub:FLDNAM><fcub:FLDVAL>{EscapeXml(value)}</fcub:FLDVAL></fcub:UDFDETAILS>";

  private static string EscapeXml(string? value) => (value ?? string.Empty)
    .Replace("&", "&amp;").Replace("<", "&lt;").Replace(">", "&gt;").Replace("\"", "&quot;").Replace("'", "&apos;");
}
