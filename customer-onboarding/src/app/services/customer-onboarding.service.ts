import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { firstValueFrom, map, Observable, throwError } from 'rxjs';
import { environment } from 'src/environments/environment';
import {
  AccountClassOption,
  AccountCreationResult,
  AccountOpeningDetails,
  AdditionalCustomerDetails,
  CustomerImageSignatureUploadRequest,
  CustomerProfileSnapshot,
  EligibleFundingAccount,
  FcubsSubmissionResult,
  NidEkycRoot,
  NidIdentity,
  SupportingDocument
} from '../models/onboarding.models';
import { AuthService } from './auth.service';
import { CustomerSessionService } from './customer-session.service';

@Injectable({
  providedIn: 'root'
})
export class CustomerOnboardingService {
  private readonly coreBaseUrl = environment.api.coreBaseUrl;
  private readonly fcubsUrl = environment.api.fcubsUrl;
  private readonly fcubsAccountUrl = environment.api.fcubsAccountUrl;
  private readonly customerImageSignatureUrl = environment.api.customerImageSignatureUrl;
  private readonly identityPhotoCache = new Map<string, Promise<string>>();
  private readonly documentUrlCache = new Map<string, string>();

  constructor(
    private http: HttpClient,
    private session: CustomerSessionService,
    private auth: AuthService
  ) {}

  getProfileSnapshot(): CustomerProfileSnapshot | null {
    const root = this.session.getNidEkycRoot<NidEkycRoot>();
    const identity = root?.identity || this.session.getNidIdentity<NidIdentity>();

    if (!identity) {
      return null;
    }

    const rawFullName = this.readFirst(identity, ['fullName', 'full_name', 'full_name_eng', 'name_eng']).trim();
    const derivedNameParts = this.deriveNameParts(rawFullName);
    const firstName = this.readFirst(identity, ['firstName', 'first_name', 'given_name', 'firstname']) || derivedNameParts.firstName || 'Customer';
    const middleName = this.readFirst(identity, ['middleName', 'middle_name', 'father_name', 'middlename']) || derivedNameParts.middleName;
    const lastName = this.readFirst(identity, ['lastName', 'last_name', 'grand_father_name', 'lastname']) || derivedNameParts.lastName;
    const fullName = rawFullName || [firstName, middleName, lastName].filter(Boolean).join(' ');
    const dateOfBirth = this.normalizeDate(this.readFirst(identity, ['dateOfBirth', 'dob', 'birthdate', 'date_of_birth']));
    const regionName = this.readFirst(identity, ['region_eng', 'region', 'addressRegion']) || 'Addis Ababa';
    const zoneName = this.readFirst(identity, ['zone_eng', 'zone', 'subcity_eng', 'subcity']) || 'N/A';
    const woredaName = this.readFirst(identity, ['woreda_eng', 'woreda', 'city_eng', 'city']) || 'N/A';
    const kebele = this.readFirst(identity, ['kebele', 'kebele_eng', 'house_no', 'houseNumber']) || 'N/A';
    const placeOfBirth = this.readFirst(identity, ['placeOfBirth', 'birth_place', 'place_of_birth']) || regionName;
    const mobileNumber = this.readFirst(identity, ['phoneNumber', 'phone', 'mobileNumber', 'mobile', 'mobile_number']) || '';
    const email = this.readFirst(identity, ['email', 'emailAddress', 'email_address']) || '';
    const nationalId = this.readFirst(identity, ['nationalId', 'national_id', 'idNumber']) || root?.psut || this.session.getFan();
    const gender = this.normalizeGender(this.readFirst(identity, ['gender', 'sex'])) || 'M';
    const regionCode = this.mapRegionCode(regionName);
    const fullAddress = [woredaName, zoneName, regionName].filter((part) => part && part !== 'N/A');
    const residenceStatus = this.readFirst(identity, ['residenceStatus_eng', 'residenceStatus', 'residence_status']) || 'Ethiopian';
    const photoBase64 = this.readFirst(identity, ['photo', 'photoBase64', 'facePhoto']);

    return {
      fullName,
      firstName,
      middleName,
      lastName,
      dateOfBirth,
      gender,
      mobileNumber,
      nationalId,
      psut: (root?.psut || '').toString().trim(),
      regionCode,
      regionName,
      zoneName,
      woredaName,
      kebele,
      addressLine1: woredaName,
      addressLine2: zoneName,
      addressLine3: kebele,
      addressLine4: fullAddress.join(', ').slice(0, 34) || 'ETHIOPIA',
      placeOfBirth,
      email,
      residenceStatus,
      photoBase64,
      nationality: environment.bankDefaults.nationality,
      country: environment.bankDefaults.country,
      minor: this.isMinor(dateOfBirth),
      rawIdentity: identity
    };
  }

  getAdditionalDetails(): AdditionalCustomerDetails | null {
    return this.session.getAdditionalDetails<AdditionalCustomerDetails>();
  }

  saveAdditionalDetails(details: AdditionalCustomerDetails): void {
    this.session.setAdditionalDetails(details);
  }

  saveAccountOpeningDetails(details: AccountOpeningDetails): void {
    this.session.setAccountOpeningDetails(details);
  }

  getAccountOpeningDetails(): AccountOpeningDetails | null {
    return this.session.getAccountOpeningDetails<AccountOpeningDetails>();
  }

  createCustomer(): Observable<FcubsSubmissionResult> {
    const snapshot = this.getProfileSnapshot();
    const details = this.getAdditionalDetails();
    const branchCode = this.getBranchCode();

    if (!snapshot || !details) {
      return throwError(() => new Error('Customer profile is incomplete. Please verify FAN and complete all mandatory fields.'));
    }

    if (!branchCode) {
      return throwError(() => new Error('Logged-in user branch code is missing. Please sign in again before creating the CIF.'));
    }

    const xmlPayload = this.buildSoapEnvelope(snapshot, details, branchCode);
    const headers = new HttpHeaders({
      'Content-Type': 'text/xml; charset=utf-8'
    });

    return this.http.post(this.fcubsUrl, xmlPayload, {
      headers,
      responseType: 'text'
    }).pipe(
      map((responseXml) => {
        const result = this.parseSoapResponse(responseXml);
        this.session.setFcubsResponse(result);
        return result;
      })
    );
  }

  uploadCustomerImageAndSignature(customerNo: string, details: AccountOpeningDetails): Observable<any> {
    const branchCode = this.getBranchCode();
    if (!branchCode) {
      return throwError(() => new Error('Logged-in user branch code is missing. Please sign in again before uploading customer image and signature.'));
    }

    const payload = this.buildCustomerImageSignaturePayload(customerNo, details, branchCode);
    return this.http.post<any>(this.customerImageSignatureUrl, payload);
  }

  createCustomerAccount(customerNo: string, details: AccountOpeningDetails): Observable<AccountCreationResult> {
    const branchCode = this.getBranchCode();
    if (!branchCode) {
      return throwError(() => new Error('Logged-in user branch code is missing. Please sign in again before creating the account.'));
    }

    const xmlPayload = this.buildAccountCreationSoapEnvelope(customerNo, details, branchCode);
    const headers = new HttpHeaders({
      'Content-Type': 'text/xml; charset=utf-8'
    });

    return this.http.post(this.fcubsAccountUrl, xmlPayload, {
      headers,
      responseType: 'text'
    }).pipe(
      map((responseXml) => {
        const result = this.parseAccountCreationResponse(responseXml);
        this.session.setAccountCreationResponse(result);
        return result;
      })
    );
  }

  getEligibleFundingAccounts(customerNo: string): Observable<EligibleFundingAccount[]> {
    return this.http.get<EligibleFundingAccount[]>(`${this.coreBaseUrl}/onboarding-records/customers/${encodeURIComponent(customerNo)}/eligible-funding-accounts`);
  }

  getAccountClasses(): Observable<AccountClassOption[]> {
    return this.http.get<AccountClassOption[]>(`${this.coreBaseUrl}/onboarding-records/account-classes`);
  }

  private buildSoapEnvelope(snapshot: CustomerProfileSnapshot, details: AdditionalCustomerDetails, branchCode: string): string {
    const defaults = environment.bankDefaults;
    const today = this.formatDate(new Date());
    const monthlyIncome = details.monthlyIncome && Number(details.monthlyIncome) > 0 ? Number(details.monthlyIncome) : null;
    const annualIncome = monthlyIncome ? (monthlyIncome * 12).toString() : '';
    const minorFlag = snapshot.minor ? 'Y' : 'N';
    const guardian = snapshot.minor ? (details.guardianName || details.motherName) : '';
    const category = snapshot.minor ? 'MINOR' : defaults.customerCategory;
    const shortName = this.buildShortName(snapshot);
    const ageProofStatus = snapshot.minor ? 'P' : 'N';
    const mobileNumber = this.normalizeMobile(details.mobileNumber || snapshot.mobileNumber);
    const placeOfBirth = details.placeOfBirth || snapshot.placeOfBirth;
    const idType = details.idType || 'FAYDA / NATIONAL ID';

    return `<?xml version="1.0" encoding="utf-8"?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:fcub="http://fcubs.ofss.com/service/FCUBSCustomerService">
  <soapenv:Header />
  <soapenv:Body>
    <fcub:CREATECUSTOMER_FSFS_REQ>
      <fcub:FCUBS_HEADER>
        <fcub:SOURCE>${this.escapeXml(defaults.source)}</fcub:SOURCE>
        <fcub:UBSCOMP>${this.escapeXml(defaults.ubsComp)}</fcub:UBSCOMP>
        <fcub:USERID>${this.escapeXml(defaults.userId)}</fcub:USERID>
        <fcub:BRANCH>${this.escapeXml(branchCode)}</fcub:BRANCH>
        <fcub:SERVICE>${this.escapeXml(defaults.service)}</fcub:SERVICE>
        <fcub:OPERATION>${this.escapeXml(defaults.operation)}</fcub:OPERATION>
      </fcub:FCUBS_HEADER>
      <fcub:FCUBS_BODY>
        <fcub:Customer-Full>
          <fcub:CUSTNO/>
          <fcub:CTYPE>I</fcub:CTYPE>
          <fcub:ADDRLN1>${this.escapeXml(snapshot.addressLine1)}</fcub:ADDRLN1>
          <fcub:ADDRLN2>${this.escapeXml(snapshot.addressLine2)}</fcub:ADDRLN2>
          <fcub:ADDRLN3>${this.escapeXml(snapshot.addressLine3)}</fcub:ADDRLN3>
          <fcub:ADDRLN4>${this.escapeXml(snapshot.addressLine4)}</fcub:ADDRLN4>
          <fcub:COUNTRY>${this.escapeXml(snapshot.country)}</fcub:COUNTRY>
          <fcub:SNAME>${this.escapeXml(shortName)}</fcub:SNAME>
          <fcub:NLTY>${this.escapeXml(snapshot.nationality)}</fcub:NLTY>
          <fcub:LBRN>${this.escapeXml(branchCode)}</fcub:LBRN>
          <fcub:CCATEG>${this.escapeXml(category)}</fcub:CCATEG>
          <fcub:FULLNAME>${this.escapeXml(snapshot.fullName)}</fcub:FULLNAME>
          <fcub:UIDNAME>NATIONAL ID</fcub:UIDNAME>
          <fcub:UIDVAL>${this.escapeXml(snapshot.nationalId)}</fcub:UIDVAL>
          <fcub:MEDIA>${this.escapeXml(defaults.media)}</fcub:MEDIA>
          <fcub:LOC>${this.escapeXml(snapshot.regionCode)}</fcub:LOC>
          <fcub:CREATEACC>N</fcub:CREATEACC>
          <fcub:TRACK_LIMITS>Y</fcub:TRACK_LIMITS>
          <fcub:Custpersonal>
            <fcub:FSTNAME>${this.escapeXml(snapshot.firstName)}</fcub:FSTNAME>
            <fcub:MIDNAME>${this.escapeXml(snapshot.middleName)}</fcub:MIDNAME>
            <fcub:LSTNAME>${this.escapeXml(snapshot.lastName)}</fcub:LSTNAME>
            <fcub:DOB>${this.escapeXml(snapshot.dateOfBirth)}</fcub:DOB>
            <fcub:GENDR>${this.escapeXml(snapshot.gender)}</fcub:GENDR>
            <fcub:NATIONID>${this.escapeXml(snapshot.nationalId)}</fcub:NATIONID>
            <fcub:MOBNUM>${this.escapeXml(mobileNumber)}</fcub:MOBNUM>
            <fcub:LANG>ENG</fcub:LANG>
            <fcub:GUARDIAN>${this.escapeXml(guardian)}</fcub:GUARDIAN>
            <fcub:SBMTAGEPROOF>${ageProofStatus}</fcub:SBMTAGEPROOF>
            <fcub:MINOR>${minorFlag}</fcub:MINOR>
            <fcub:KYCSTAT>N</fcub:KYCSTAT>
            <fcub:TITLE>${this.escapeXml(details.title)}</fcub:TITLE>
            <fcub:PLACEOFBIRTH>${this.escapeXml(placeOfBirth)}</fcub:PLACEOFBIRTH>
            <fcub:BIRTHCOUNTRY>${this.escapeXml(snapshot.country)}</fcub:BIRTHCOUNTRY>
            <fcub:MOBISDNO>251</fcub:MOBISDNO>
            <fcub:MOTHERMAIDN_NAME>${this.escapeXml(details.motherName)}</fcub:MOTHERMAIDN_NAME>
            <fcub:Custdomestic>
              <fcub:MARITALSTAT>${this.escapeXml(details.maritalStatus)}</fcub:MARITALSTAT>
            </fcub:Custdomestic>
            <fcub:Custprof>
              <fcub:EMPSTAT>U</fcub:EMPSTAT>
              <fcub:AMTCCY1>ETB</fcub:AMTCCY1>
            </fcub:Custprof>
          </fcub:Custpersonal>
          <fcub:Custdoc-Chklist>
            <fcub:DOCCATEGORY>KEBELE_ID</fcub:DOCCATEGORY>
            <fcub:DOCUMENTNAME>KEBELE/WOREDA ID CARD NUMBER IF GIVEN BY REGION OF RESIDENCE</fcub:DOCUMENTNAME>
            <fcub:DOCUMENT_TYPE>KEBELE_ID</fcub:DOCUMENT_TYPE>
            <fcub:CHECKED>Y</fcub:CHECKED>
            <fcub:DATEREQ>${today}</fcub:DATEREQ>
            <fcub:ACTUALDATE>${today}</fcub:ACTUALDATE>
            <fcub:EXPDATE>${today}</fcub:EXPDATE>
          </fcub:Custdoc-Chklist>
          ${this.udf('TIN_STATUS', 'NO')}
          ${this.udf('TAX_IDENTIFICATION_NUMBER', details.tinNumber || '')}
          ${this.udf('AVERAGE_MONTHLY_INCOME', monthlyIncome ? monthlyIncome.toString() : '')}
          ${this.udf('AVERAGE_ANNUAL_INCOME', annualIncome)}
          ${this.udf('OCCUPATION', details.occupation)}
          ${this.udf('WORK_POSITION', details.workPosition)}
          ${this.udf('EMPLOYER', details.employer)}
          ${this.udf('STAFF_STATUS', details.staffStatus)}
          ${this.udf('H_NO', '')}
          ${this.udf('REGISTRATION_STATUS', 'NO')}
          ${this.udf('DATE_OF_ESTABLISHMENT', '')}
          ${this.udf('REGISTRATION_NUMBER', '')}
          ${this.udf('TRADE_LICENSE_NUMBER', '')}
          ${this.udf('DISTRICT', snapshot.woredaName)}
          ${this.udf('ZIP CODE', '')}
          ${this.udf('P_O_BOX', '')}
          ${this.udf('MOTHER NAME', details.motherName)}
          ${this.udf('ID_ISSUED_BY', 'GOVERNMENT')}
          ${this.udf('ID_TYPE', idType)}
          ${this.udf('SOCIAL SECURITY NUMBER', '')}
          ${this.udf('EMPLOYEMENT ID', details.dmsReferenceNumber)}
          ${this.udf('INTERNATIONAL TELE NO', '')}
          ${this.udf('US PERSON', 'NO')}
          ${this.udf('RISK_PROFILE', 'Low')}
          ${this.udf('SOURCE OF CUSTOMER', 'BRANCH')}
          ${this.udf('CUSTOMER FOLLOW UP', '')}
        </fcub:Customer-Full>
      </fcub:FCUBS_BODY>
    </fcub:CREATECUSTOMER_FSFS_REQ>
  </soapenv:Body>
</soapenv:Envelope>`;
  }

  private udf(name: string, value: string): string {
    const fieldValue = value ? `<fcub:FLDVAL>${this.escapeXml(value)}</fcub:FLDVAL>` : '';
    return `<fcub:UDFDETAILS><fcub:FLDNAM>${this.escapeXml(name)}</fcub:FLDNAM>${fieldValue}</fcub:UDFDETAILS>`;
  }

  private parseSoapResponse(xmlText: string): FcubsSubmissionResult {
    const parser = new DOMParser();
    const documentNode = parser.parseFromString(xmlText, 'text/xml');
    const parserError = documentNode.getElementsByTagName('parsererror')[0];

    if (parserError) {
      return {
        success: false,
        customerNumber: '',
        accountNumber: '',
        rawResponse: xmlText,
        message: 'FCUBS returned an unreadable XML response.'
      };
    }

    const customerNumber = this.findXmlValue(documentNode, ['CUSTNO', 'CUSTOMER_NO', 'CUST_NO']);
    const accountNumber = this.findXmlValue(documentNode, ['CREATEDACCOUNT', 'ACC', 'ACCOUNT']);
    const errorCode = this.findXmlValue(documentNode, ['ECODE']);
    const errorMessage = this.findXmlValue(documentNode, ['EDESC', 'ERROR', 'ERROR_DESC', 'FCUBS_ERROR']);
    const formattedError = errorMessage ? `${errorCode ? `${errorCode}: ` : ''}${errorMessage}` : '';
    const duplicateCustomerNumber = this.extractCustomerNumberFromError(errorMessage);
    const resolvedCustomerNumber = customerNumber || duplicateCustomerNumber;
    const duplicateCustomerDetected = errorCode === 'ST-CIF24' && !!duplicateCustomerNumber;
    const message = duplicateCustomerDetected
      ? `Existing customer found with CIF ${duplicateCustomerNumber}. Continuing with that customer number.`
      : formattedError || (resolvedCustomerNumber
      ? `Customer created successfully${accountNumber ? ` with account ${accountNumber}` : ''}.`
      : 'FCUBS response received. Review the raw response for details.');

    return {
      success: duplicateCustomerDetected || (!!resolvedCustomerNumber && !formattedError),
      customerNumber: resolvedCustomerNumber,
      accountNumber,
      rawResponse: xmlText,
      message
    };
  }

  private buildCustomerImageSignaturePayload(customerNo: string, details: AccountOpeningDetails, branchCode: string): CustomerImageSignatureUploadRequest {
    const defaults = environment.bankDefaults;
    const generatedSeq = Number(`${Date.now()}`.slice(-7));
    const signatureName = `${customerNo}_signature.${details.signatureFileType.toLowerCase()}`;
    const imageName = details.imageFileName || `${customerNo}_${customerNo}img.${details.imageFileType.toLowerCase()}`;

    return {
      customerNo,
      cifSigId: customerNo,
      branchCode,
      signatureBase64: details.signatureBase64,
      signatureFileType: details.signatureFileType,
      signatureSpecimenNo: 1,
      signatureSpecimenSeqNo: generatedSeq,
      signatureRecordStat: 'N',
      signatureStatus: 'N',
      imageBase64: details.imageBase64,
      imageFileName: imageName,
      imageSeqNo: 1,
      imageSpecimenSeqNo: generatedSeq,
      imageStatus: 'N',
      imgMasterRecordStat: 'O',
      imgMasterAuthStat: 'A',
      makerId: defaults.makerId,
      checkerId: defaults.checkerId,
      modNo: 1,
      onceAuth: 'Y',
      functionId: 'STDCIFIS',
      tableName: 'STTM_CUST_IMG_MASTER',
      recordLogRecordStat: 'O',
      recordLogAuthStat: 'A',
      cifSigName: signatureName,
      cifSigTitle: signatureName,
      sigMasterRecordStat: 'O',
      sigMasterAuthStat: 'A',
      sigMasterOnceAuth: 'Y',
      replToAcc: 'Y'
    };
  }

  buildIdentityPhotoDataUrl(photoBase64: string | null | undefined): string {
    const normalized = this.normalizeBase64(photoBase64);
    if (!normalized) {
      return '';
    }

    if (normalized.startsWith('data:')) {
      return normalized;
    }

    return `data:image/jpeg;base64,${normalized}`;
  }

  async resolveIdentityPhotoPreview(photoBase64: string | null | undefined): Promise<string> {
    const normalized = this.normalizeBase64(photoBase64);
    if (!normalized) {
      return '';
    }

    const cached = this.identityPhotoCache.get(normalized);
    if (cached) {
      return cached;
    }

    const resolving = this.buildIdentityPhotoPreview(normalized);
    this.identityPhotoCache.set(normalized, resolving);
    return resolving;
  }

  buildDocumentDownloadUrl(document: SupportingDocument): string {
    const normalizedBase64 = this.normalizeBase64(document?.base64);
    if (!normalizedBase64) {
      return '';
    }

    const resolvedMimeType = this.resolveDocumentMimeType(document?.mimeType, document?.fileName);
    const cacheKey = `${document?.id || document?.category || document?.fileName || 'document'}|${resolvedMimeType}|${normalizedBase64.slice(0, 48)}`;
    const cachedUrl = this.documentUrlCache.get(cacheKey);
    if (cachedUrl) {
      return cachedUrl;
    }

    try {
      const binaryString = window.atob(normalizedBase64);
      const bytes = new Uint8Array(binaryString.length);
      for (let index = 0; index < binaryString.length; index += 1) {
        bytes[index] = binaryString.charCodeAt(index);
      }

      const blob = new Blob([bytes], { type: resolvedMimeType });
      const objectUrl = window.URL.createObjectURL(blob);
      this.documentUrlCache.set(cacheKey, objectUrl);
      return objectUrl;
    } catch {
      return `data:${resolvedMimeType};base64,${normalizedBase64}`;
    }
  }

  resolveDocumentMimeType(mimeType: string | null | undefined, fileName?: string | null): string {
    const normalizedMimeType = String(mimeType || '').trim().toLowerCase();
    if (normalizedMimeType && normalizedMimeType !== 'application/octet-stream') {
      return normalizedMimeType;
    }

    const extension = (fileName || '').split('.').pop()?.trim().toLowerCase();
    switch (extension) {
      case 'pdf':
        return 'application/pdf';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      default:
        return normalizedMimeType || 'application/octet-stream';
    }
  }

  private buildAccountCreationSoapEnvelope(customerNo: string, details: AccountOpeningDetails, branchCode: string): string {
    const defaults = environment.bankDefaults;
    const payInOption = details.fundingSourceType === 'ACCOUNT' ? 'A' : 'G';
    const accountCode =
      details.accountCode ||
      defaults.accountClassCodes?.[details.accountClass] ||
      defaults.defaultAccountCode ||
      '73';
    const accountReference = `${branchCode}${accountCode}CCCCS`;

    return `<?xml version="1.0" encoding="utf-8"?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:fcub="http://fcubs.ofss.com/service/FCUBSAccService">
  <soapenv:Header/>
  <soapenv:Body>
    <fcub:CREATECUSTACC_FSFS_REQ>
      <fcub:FCUBS_HEADER>
        <fcub:SOURCE>${this.escapeXml(defaults.source)}</fcub:SOURCE>
        <fcub:UBSCOMP>${this.escapeXml(defaults.ubsComp)}</fcub:UBSCOMP>
        <fcub:USERID>${this.escapeXml(defaults.userId)}</fcub:USERID>
        <fcub:BRANCH>${this.escapeXml(branchCode)}</fcub:BRANCH>
        <fcub:SERVICE>${this.escapeXml(defaults.accountService)}</fcub:SERVICE>
        <fcub:OPERATION>${this.escapeXml(defaults.accountOperation)}</fcub:OPERATION>
      </fcub:FCUBS_HEADER>
      <fcub:FCUBS_BODY>
        <fcub:Cust-Account-Full>
          <fcub:BRN>${this.escapeXml(branchCode)}</fcub:BRN>
          <fcub:ACC>${this.escapeXml(accountReference)}</fcub:ACC>
          <fcub:CUSTNO>${this.escapeXml(customerNo)}</fcub:CUSTNO>
          <fcub:ACCLS>${this.escapeXml(details.accountClass)}</fcub:ACCLS>
          <fcub:CCY>ETB</fcub:CCY>
          <fcub:PAY_IN_OPTION>${this.escapeXml(payInOption)}</fcub:PAY_IN_OPTION>
          <fcub:ACC_OPENING_AMT>${this.escapeXml(String(details.openingAmount))}</fcub:ACC_OPENING_AMT>
          <fcub:LOC>${this.escapeXml(defaults.branchLocation)}</fcub:LOC>
          <fcub:MEDIA>${this.escapeXml(defaults.media)}</fcub:MEDIA>
          <fcub:ACCTYPE>${this.escapeXml(this.resolveAccountType(details.accountClass))}</fcub:ACCTYPE>
        </fcub:Cust-Account-Full>
      </fcub:FCUBS_BODY>
    </fcub:CREATECUSTACC_FSFS_REQ>
  </soapenv:Body>
</soapenv:Envelope>`;
  }

  private parseAccountCreationResponse(xmlText: string): AccountCreationResult {
    const parser = new DOMParser();
    const documentNode = parser.parseFromString(xmlText, 'text/xml');
    const parserError = documentNode.getElementsByTagName('parsererror')[0];

    if (parserError) {
      return {
        success: false,
        accountNumber: '',
        rawResponse: xmlText,
        message: 'FCUBS account service returned an unreadable XML response.'
      };
    }

    const accountNumber = this.findXmlValue(documentNode, ['ACC', 'ACCOUNT']);
    const errorCode = this.findXmlValue(documentNode, ['ECODE']);
    const errorMessage = this.findXmlValue(documentNode, ['EDESC', 'ERROR', 'ERROR_DESC', 'FCUBS_ERROR']);
    const formattedError = errorMessage ? `${errorCode ? `${errorCode}: ` : ''}${errorMessage}` : '';

    return {
      success: !!accountNumber && !formattedError,
      accountNumber,
      rawResponse: xmlText,
      message: formattedError || (accountNumber
        ? `Account created successfully: ${accountNumber}.`
        : 'FCUBS account response received. Review the raw response for details.')
    };
  }

  private findXmlValue(documentNode: Document, localNames: string[]): string {
    for (const name of localNames) {
      const namespacedNodes = documentNode.getElementsByTagNameNS('*', name);
      if (namespacedNodes.length > 0 && namespacedNodes[0].textContent) {
        return namespacedNodes[0].textContent.trim();
      }

      const plainNodes = documentNode.getElementsByTagName(name);
      if (plainNodes.length > 0 && plainNodes[0].textContent) {
        return plainNodes[0].textContent.trim();
      }
    }

    return '';
  }

  private readFirst(identity: NidIdentity, keys: string[]): string {
    for (const key of keys) {
      const value = identity?.[key];
      if (value !== undefined && value !== null && String(value).trim()) {
        return String(value).trim();
      }
    }

    return '';
  }

  private normalizeDate(value: string): string {
    if (!value) {
      return this.formatDate(new Date(1990, 0, 1));
    }

    if (/^\d{4}-\d{2}-\d{2}$/.test(value)) {
      return value;
    }

    const parsed = new Date(value);
    if (Number.isNaN(parsed.getTime())) {
      return this.formatDate(new Date(1990, 0, 1));
    }

    return this.formatDate(parsed);
  }

  private formatDate(date: Date): string {
    const year = date.getFullYear();
    const month = `${date.getMonth() + 1}`.padStart(2, '0');
    const day = `${date.getDate()}`.padStart(2, '0');
    return `${year}-${month}-${day}`;
  }

  private normalizeGender(value: string): 'M' | 'F' {
    const normalized = (value || '').toLowerCase();
    return normalized.startsWith('f') ? 'F' : 'M';
  }

  private normalizeBase64(value: string | null | undefined): string {
    return String(value || '').replace(/\s+/g, '').trim();
  }

  private async buildIdentityPhotoPreview(normalized: string): Promise<string> {
    if (normalized.startsWith('data:')) {
      return normalized;
    }

    try {
      const preview = await firstValueFrom(
        this.http.post<{ dataUrl?: string }>(`${this.coreBaseUrl}/identity-photo/preview`, {
          photoBase64: normalized
        })
      );

      if (preview?.dataUrl) {
        return preview.dataUrl;
      }
    } catch {
      // Fall back to a browser-native preview for standard image types.
    }

    return `data:image/jpeg;base64,${normalized}`;
  }

  private normalizeMobile(value: string): string {
    const digits = (value || '').replace(/\D/g, '');
    if (digits.startsWith('251') && digits.length === 12) {
      return `0${digits.slice(3)}`;
    }

    if (digits.length >= 10) {
      return digits.slice(-10);
    }

    return digits;
  }

  private isMinor(dateOfBirth: string): boolean {
    const birthDate = new Date(dateOfBirth);
    if (Number.isNaN(birthDate.getTime())) {
      return false;
    }

    const today = new Date();
    let age = today.getFullYear() - birthDate.getFullYear();
    const monthDelta = today.getMonth() - birthDate.getMonth();
    if (monthDelta < 0 || (monthDelta === 0 && today.getDate() < birthDate.getDate())) {
      age -= 1;
    }

    return age < 18;
  }

  private mapRegionCode(regionName: string): string {
    const normalized = (regionName || '').toLowerCase();
    if (normalized.includes('addis')) return 'AA';
    if (normalized.includes('afar')) return 'AFA';
    if (normalized.includes('amhara')) return 'AMA';
    if (normalized.includes('benishangul')) return 'BEN';
    if (normalized.includes('dire')) return 'DIR';
    if (normalized.includes('gambela')) return 'GAM';
    if (normalized.includes('harari')) return 'HA';
    if (normalized.includes('oromia')) return 'ORO';
    if (normalized.includes('somali')) return 'SOM';
    if (normalized.includes('south') || normalized.includes('snn')) return 'SNN';
    if (normalized.includes('tigray')) return 'TIG';
    return environment.bankDefaults.branchLocation;
  }

  private deriveNameParts(fullName: string): { firstName: string; middleName: string; lastName: string } {
    const parts = (fullName || '')
      .split(/\s+/)
      .map((part) => part.trim())
      .filter(Boolean);

    if (parts.length === 0) {
      return { firstName: '', middleName: '', lastName: '' };
    }

    if (parts.length === 1) {
      return { firstName: parts[0], middleName: '', lastName: '' };
    }

    if (parts.length === 2) {
      return { firstName: parts[0], middleName: parts[1], lastName: '' };
    }

    return {
      firstName: parts[0],
      middleName: parts.slice(1, -1).join(' '),
      lastName: parts[parts.length - 1]
    };
  }

  private buildShortName(snapshot: CustomerProfileSnapshot): string {
    const compactName = (snapshot.fullName || '')
      .replace(/[^A-Za-z]/g, '')
      .toUpperCase();
    const namePrefix = (compactName.slice(0, 3) || 'CIF').padEnd(3, 'X');
    const uniqueDigits = `${Date.now()}`.slice(-4);
    return `${namePrefix}${uniqueDigits}`.slice(0, 20);
  }

  private extractCustomerNumberFromError(errorMessage: string): string {
    const match = (errorMessage || '').match(/Customer Number\s+(\d+)/i);
    return match?.[1] || '';
  }

  private resolveAccountType(accountClass: string): string {
    const normalized = (accountClass || '').toUpperCase();
    if (normalized.startsWith('C') || normalized.startsWith('WC')) {
      return 'C';
    }

    if (normalized.startsWith('TD') || normalized.startsWith('TE')) {
      return 'T';
    }

    return 'S';
  }

  private escapeXml(value: string): string {
    return String(value || '')
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&apos;');
  }

  private getBranchCode(): string {
    return (this.auth.getBranchCode() || '').trim();
  }
}
