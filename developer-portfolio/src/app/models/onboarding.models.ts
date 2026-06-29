export interface IdaOtpRequest {
  individualId: string;
  individualIdType: 'FAN';
  otpChannel: string[];
}

export interface IdaOtpResponse {
  id?: string;
  version?: string;
  transactionID?: string;
  transactionId?: string;
  responseTime?: string;
  errors?: any;
  response?: {
    maskedMobile?: string;
    maskedEmail?: string;
  };
}

export interface IdaEkycRequest {
  individualId: string;
  individualIdType: 'FAN';
  otp: string;
  transactionId: string;
}

export interface NidIdentity {
  [key: string]: any;
}

export interface NidEkycRoot {
  kycStatus: boolean;
  psut: string;
  identity: NidIdentity | null;
}

export interface AdditionalCustomerDetails {
  motherName: string;
  occupation: string;
  monthlyIncome: number;
  dmsReferenceNumber: string;
  employer: string;
  workPosition: string;
  title: string;
  maritalStatus: 'S' | 'M';
  staffStatus: 'STAFF' | 'NON_STAFF';
  accountOpeningAmount: number;
  guardianName?: string;
}

export interface CustomerProfileSnapshot {
  fullName: string;
  firstName: string;
  middleName: string;
  lastName: string;
  dateOfBirth: string;
  gender: 'M' | 'F';
  mobileNumber: string;
  nationalId: string;
  psut: string;
  regionCode: string;
  regionName: string;
  zoneName: string;
  woredaName: string;
  kebele: string;
  addressLine1: string;
  addressLine2: string;
  addressLine3: string;
  addressLine4: string;
  placeOfBirth: string;
  nationality: string;
  country: string;
  minor: boolean;
  rawIdentity: NidIdentity | null;
}

export interface FcubsSubmissionResult {
  success: boolean;
  customerNumber: string;
  accountNumber: string;
  rawResponse: string;
  message: string;
}
