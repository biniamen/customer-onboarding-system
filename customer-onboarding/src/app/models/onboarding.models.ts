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
  monthlyIncome: number | null;
  dmsReferenceNumber: string;
  employer: string;
  workPosition: string;
  title: string;
  maritalStatus: 'S' | 'M';
  staffStatus: 'STAFF' | 'NON_STAFF';
  mobileNumber: string;
  email: string;
  placeOfBirth: string;
  idType: string;
  residentIdNumber?: string;
  tinNumber?: string;
  guardianName?: string;
}

export type FundingSourceType = 'CASH' | 'ACCOUNT' | 'GL';

export interface AccountOpeningDetails {
  accountClass: string;
  accountClassName: string;
  accountCode: string;
  accountNumberTemplate: string;
  openingAmount: number;
  fundingSourceType: FundingSourceType;
  fundingSourceValue: string;
  signatureBase64: string;
  signatureFileType: string;
  signatureFileName: string;
  imageBase64: string;
  imageFileType: string;
  imageFileName: string;
  uploadedDocuments: SupportingDocument[];
}

export interface EligibleFundingAccount {
  accountNumber: string;
  accountDescription: string;
  currency: string;
  accountClass: string;
  noDebitStatus: string;
  dormantStatus: string;
  joinIndicator: string;
}

export interface AccountClassOption {
  code: string;
  name: string;
  accountCode: string;
  minimumOpeningBalance: number;
  currencyCode: string;
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
  email: string;
  residenceStatus: string;
  photoBase64: string;
  nationality: string;
  country: string;
  minor: boolean;
  rawIdentity: NidIdentity | null;
}

export interface SupportingDocument {
  id: string;
  category: string;
  displayName: string;
  fileName: string;
  mimeType: string;
  base64: string;
  required: boolean;
  uploadedAtUtc: string;
}

export interface FcubsSubmissionResult {
  success: boolean;
  customerNumber: string;
  accountNumber: string;
  rawResponse: string;
  message: string;
}

export interface CustomerImageSignatureUploadRequest {
  customerNo: string;
  cifSigId: string;
  branchCode: string;
  signatureBase64: string;
  signatureFileType: string;
  signatureSpecimenNo: number;
  signatureSpecimenSeqNo: number;
  signatureRecordStat: string;
  signatureStatus: string;
  imageBase64: string;
  imageFileName: string;
  imageSeqNo: number;
  imageSpecimenSeqNo: number;
  imageStatus: string;
  imgMasterRecordStat: string;
  imgMasterAuthStat: string;
  makerId: string;
  checkerId: string;
  modNo: number;
  onceAuth: string;
  functionId: string;
  tableName: string;
  recordLogRecordStat: string;
  recordLogAuthStat: string;
  cifSigName: string;
  cifSigTitle: string;
  sigMasterRecordStat: string;
  sigMasterAuthStat: string;
  sigMasterOnceAuth: string;
  replToAcc: string;
}

export interface AccountCreationResult {
  success: boolean;
  accountNumber: string;
  rawResponse: string;
  message: string;
}

export type UserRole =
  | 'ADMIN'
  | 'SYSTEM_ADMIN'
  | 'SENIOR_MANAGEMENT'
  | 'BRANCH_BANKING'
  | 'HR'
  | 'MAKER'
  | 'CHECKER'
  | 'RENTAL_MAKER'
  | 'RENTAL_CHECKER'
  | 'REPORT_VIEWER'
  | 'KYC_UNIT';

export interface AuthUser {
  id: string;
  username: string;
  fullName: string;
  phoneNumber: string;
  branchCode: string;
  branchName: string;
  role: UserRole;
  mustChangePassword: boolean;
}

export interface LoginResponse {
  token: string;
  expiresAtUtc: string;
  user: AuthUser;
}

export interface ChangePasswordRequest {
  currentPassword: string;
  newPassword: string;
}

export interface BranchOption {
  branchCode: string;
  branchName: string;
}

export interface AdminUserListItem {
  id: string;
  username: string;
  fullName: string;
  phoneNumber: string;
  branchCode: string;
  branchName: string;
  role: UserRole;
  isActive: boolean;
  mustChangePassword: boolean;
  createdAtUtc: string;
  lastLoginAtUtc?: string | null;
  passwordChangedAtUtc?: string | null;
}

export interface CreateUserRequest {
  username: string;
  fullName: string;
  phoneNumber: string;
  branchCode: string;
  role: UserRole;
  password: string;
  isActive: boolean;
}

export interface UpdateUserRequest {
  fullName: string;
  phoneNumber: string;
  branchCode: string;
  role: UserRole;
  isActive: boolean;
}

export interface ResetUserPasswordRequest {
  newPassword: string;
  forcePasswordChange: boolean;
}

export interface ExternalDirectoryUser {
  id: string;
  employeeId: string;
  firstName: string;
  middleName: string;
  lastName: string;
  fullEmployeeName: string;
  gender: string;
  email: string;
  phoneNumber: string;
  isActive: boolean;
  branchId?: string | null;
  branchName?: string | null;
  branchCode?: string | null;
  departmentId?: string | null;
  departmentName?: string | null;
  roleId?: string | null;
  roleName?: string | null;
  positionId?: string | null;
  positionName?: string | null;
  mustChangePassword: boolean;
  lastPasswordResetAt?: string | null;
  lastPasswordResetByUserId?: string | null;
  createdAt?: string | null;
  updatedAt?: string | null;
}

export interface PasswordMessageTemplate {
  templateType: string;
  title: string;
  body: string;
  isActive: boolean;
  updatedAtUtc: string;
  updatedByUserName: string;
}

export interface UpdatePasswordMessageTemplateRequest {
  title: string;
  body: string;
  isActive: boolean;
}

export interface SendPasswordResetSmsRequest {
  externalUserId: string;
  systemName: string;
  password: string;
}

export interface SendNewUserCredentialSmsRequest {
  externalUserId: string;
  systemName: string;
  username: string;
  password: string;
}

export interface PasswordMessageDispatchResult {
  templateType: string;
  externalUserId: string;
  fullEmployeeName: string;
  phoneNumber: string;
  systemName: string;
  messageBody: string;
  sent: boolean;
  providerMessage: string;
  rawProviderResponse: string;
  sentAtUtc: string;
}

export interface EmployeeDirectoryStats {
  totalEmployees: number;
  activeEmployees: number;
  lastImportedAtUtc?: string | null;
  lastSourceFileName?: string | null;
}

export interface EmployeeDirectoryImportResult {
  sourceFileName: string;
  sourceSheetName: string;
  processedRows: number;
  insertedRows: number;
  updatedRows: number;
  deactivatedRows: number;
  totalActiveEmployees: number;
  importedAtUtc: string;
}

export interface EmployeeDirectoryEntryRecord {
  id: string;
  sequenceNumber?: number | null;
  employeeReference: string;
  employeeCode: string;
  internalNumber: string;
  internalNumberExtension: string;
  firstName: string;
  middleName: string;
  lastName: string;
  fullEmployeeName: string;
  gender: string;
  contactAddress: string;
  phoneNumber: string;
  currentPosition: string;
  classification: string;
  assignedUnitName: string;
  branchGrade: string;
  branchCode: string;
  district: string;
  employmentDate?: string | null;
  isActive: boolean;
  sourceFileName: string;
  sourceSheetName: string;
  importedAtUtc: string;
  updatedAtUtc: string;
}

export interface EmployeeDirectoryPagedResponse {
  page: number;
  pageSize: number;
  totalRecords: number;
  totalPages: number;
  items: EmployeeDirectoryEntryRecord[];
}

export interface EmployeeDirectoryQuery {
  search?: string;
  branchCode?: string;
  isActive?: boolean;
  page?: number;
  pageSize?: number;
}

export interface UpdateEmployeeDirectoryEntryRequest {
  sequenceNumber?: number | null;
  employeeReference: string;
  employeeCode: string;
  internalNumber: string;
  internalNumberExtension: string;
  firstName: string;
  middleName: string;
  lastName: string;
  fullEmployeeName: string;
  gender: string;
  contactAddress: string;
  phoneNumber: string;
  currentPosition: string;
  classification: string;
  assignedUnitName: string;
  branchGrade: string;
  branchCode: string;
  district: string;
  employmentDate?: string | null;
  isActive: boolean;
}

export interface PasswordMessageAuditLogItem {
  id: number;
  action: string;
  operatorUsername?: string | null;
  operatorFullName?: string | null;
  recipientFullEmployeeName?: string | null;
  recipientPhoneNumber?: string | null;
  systemName?: string | null;
  provisionedUsername?: string | null;
  sent?: boolean | null;
  ipAddress?: string | null;
  createdAtUtc: string;
}

export interface PasswordMessageAuditLogResponse {
  page: number;
  pageSize: number;
  totalRecords: number;
  totalPages: number;
  items: PasswordMessageAuditLogItem[];
}

export interface PasswordMessageAuditLogQuery {
  search?: string;
  fromDate?: string;
  toDate?: string;
  page?: number;
  pageSize?: number;
}

export interface ApprovalSubmissionPayload {
  fan: string;
  psut: string;
  customerNumber: string;
  customerName: string;
  branchCode: string;
  accountClass: string;
  accountClassName: string;
  openingAmount: number;
  fundingSourceType: FundingSourceType;
  fundingSourceValue: string;
  accountReference: string;
  snapshot: CustomerProfileSnapshot;
  additionalDetails: AdditionalCustomerDetails;
  cifResponse: FcubsSubmissionResult;
  accountDetails: AccountOpeningDetails;
  uploadResponse: any;
}

export interface ApprovalRecord {
  id: string;
  caseReference: string;
  status: string;
  customerNumber: string;
  customerName: string;
  branchCode: string;
  accountClass: string;
  accountClassName: string;
  openingAmount: number;
  fundingSourceType: string;
  fundingSourceValue: string;
  accountReference: string;
  assetsReady: boolean;
  makerUsername: string;
  makerFullName: string;
  submittedAtUtc: string;
  checkerUsername?: string | null;
  checkerFullName?: string | null;
  reviewedAtUtc?: string | null;
  kycReviewerUsername?: string | null;
  kycReviewerFullName?: string | null;
  kycReviewedAtUtc?: string | null;
  checkerComment?: string | null;
  accountNumber?: string | null;
  lastError?: string | null;
  email: string;
  mobileNumber: string;
  placeOfBirth: string;
  idType: string;
  residentIdNumber?: string | null;
  tinNumber?: string | null;
  hasCustomerPhoto: boolean;
  hasSignature: boolean;
  hasRequiredDocuments: boolean;
  documentsJson: string;
  snapshotJson: string;
  additionalDetailsJson: string;
  cifResponseJson: string;
  accountDetailsJson: string;
  uploadResponseJson: string;
}

export interface OnboardingReportQuery {
  search?: string;
  status?: string;
  fromDate?: string;
  toDate?: string;
  page?: number;
  pageSize?: number;
  sortBy?: string;
  sortDirection?: 'asc' | 'desc';
}

export interface OnboardingReportResponse {
  page: number;
  pageSize: number;
  totalRecords: number;
  totalPages: number;
  items: ApprovalRecord[];
}

export interface OnboardingStatusBreakdown {
  total: number;
  pending: number;
  accountCreated: number;
  kycReviewed: number;
  failed: number;
  rejected: number;
  totalOpeningAmount: number;
}

export interface OnboardingBranchStats {
  branchCode: string;
  branchName: string;
  today: OnboardingStatusBreakdown;
  grandTotal: OnboardingStatusBreakdown;
}

export interface OnboardingDashboardStats {
  scope: string;
  branchCode?: string | null;
  rangeStartUtc: string;
  rangeEndUtc: string;
  today: OnboardingStatusBreakdown;
  grandTotal: OnboardingStatusBreakdown;
  branches: OnboardingBranchStats[];
}

export interface TelebirrAccountLookupResult {
  accountNumber: string;
  accountBranchCode: string;
  customerNumber: string;
  customerName: string;
  accountClass: string;
  currency: string;
  availableBalance: number;
  noDebitStatus: string;
  noCreditStatus: string;
  frozenStatus: string;
  responseStatus: string;
  canProceed: boolean;
  minimumRemainingBalance: number;
  message: string;
  rawResponse: string;
}

export interface TelebirrAgentLookupResult {
  telebirrShortCode: string;
  telebirrOrganizationName: string;
  resultType: string;
  resultCode: string;
  resultDesc: string;
  conversationId: string;
  isValid: boolean;
  message: string;
  rawResponse: string;
}

export interface TelebirrTransferSubmitRequest {
  accountNumber: string;
  telebirrShortCode: string;
  amount: number;
  narration?: string | null;
}

export interface TelebirrTransferRecord {
  id: number;
  accountNumber: string;
  accountBranchCode?: string | null;
  customerName?: string | null;
  telebirrShortCode: string;
  telebirrOrganizationName?: string | null;
  amount: number;
  currency: string;
  narration: string;
  status: string;
  makerBranchId?: number | null;
  makerUserName?: string | null;
  checkerUserName?: string | null;
  createdAt: string;
  approvedAt?: string | null;
  rejectedAt?: string | null;
  rejectionReason?: string | null;
  transactionId?: string | null;
  conversationId?: string | null;
  originatorConversationId?: string | null;
  cbsReference?: string | null;
  cbsMessageStatus?: string | null;
  cbsResponseDesc?: string | null;
  reversalReference?: string | null;
  reversalStatus?: string | null;
  reversalResponseDesc?: string | null;
  responseCode?: string | null;
  responseDesc?: string | null;
  serviceStatus?: string | null;
  resultType?: string | null;
  resultCode?: string | null;
  resultDesc?: string | null;
}

export interface TelebirrTransferReportQuery {
  search?: string;
  status?: string;
  fromDate?: string;
  toDate?: string;
  page?: number;
  pageSize?: number;
  sortBy?: string;
  sortDirection?: 'asc' | 'desc';
}

export interface TelebirrTransferReportResponse {
  page: number;
  pageSize: number;
  totalRecords: number;
  totalPages: number;
  items: TelebirrTransferRecord[];
}

export interface TelebirrStatusBreakdown {
  total: number;
  approved: number;
  failed: number;
  rejected: number;
  pending: number;
  distinctAgents: number;
  totalTransferredAmount: number;
}

export interface TelebirrBranchStats {
  branchCode: string;
  branchName: string;
  today: TelebirrStatusBreakdown;
  grandTotal: TelebirrStatusBreakdown;
}

export interface TelebirrDashboardUserStats {
  totalUsers: number;
  activeUsers: number;
  inactiveUsers: number;
}

export interface TelebirrDashboardStats {
  scope: 'ALL_BRANCHES' | 'BRANCH_ONLY' | string;
  branchCode?: string | null;
  rangeStartUtc: string;
  rangeEndUtc: string;
  today: TelebirrStatusBreakdown;
  grandTotal: TelebirrStatusBreakdown;
  branches: TelebirrBranchStats[];
  userStats?: TelebirrDashboardUserStats | null;
}

export interface RentalPaymentInquiryResult {
  canProceed: boolean;
  message: string;
  manifestId?: string | null;
  billId: string;
  balerId: string;
  customerId?: string | null;
  customerName?: string | null;
  tenantName?: string | null;
  ownerName?: string | null;
  ownerAccountNumber?: string | null;
  propertyName?: string | null;
  billDescription?: string | null;
  reason?: string | null;
  amountDue: number;
  baseAmount: number;
  penaltyAmount: number;
  currentPeriod?: string | null;
  penaltyType?: string | null;
  isOverdue: boolean;
  cashDebitGlAccount: string;
  dueDate?: string | null;
  rawResponse: string;
}

export type RentalPaymentMode = 'ACCOUNT' | 'CASH';

export interface RentalPaymentSubmitRequest {
  manifestId: string;
  billId: string;
  amount: number;
  paymentMode: RentalPaymentMode;
  debitAccount?: string | null;
  paidAt?: string | null;
  tellerId?: string | null;
}

export interface RentalPaymentRecord {
  id: number;
  manifestId: string;
  billId: string;
  balerId: string;
  customerId?: string | null;
  customerName?: string | null;
  tenantName?: string | null;
  ownerName?: string | null;
  ownerAccountNumber?: string | null;
  propertyName?: string | null;
  billDescription?: string | null;
  reason?: string | null;
  amountDue: number;
  baseAmount: number;
  penaltyAmount: number;
  paidAmount?: number | null;
  status: string;
  statusMessage?: string | null;
  debitAccount?: string | null;
  paymentMode?: RentalPaymentMode | string | null;
  makerUserName?: string | null;
  makerBranchCode?: string | null;
  checkerUserName?: string | null;
  checkerBranchCode?: string | null;
  checkerComment?: string | null;
  approvedAt?: string | null;
  rejectedAt?: string | null;
  rejectionReason?: string | null;
  cbsReference?: string | null;
  confirmationCode?: string | null;
  paidAtLocation?: string | null;
  tellerId?: string | null;
  dueDate?: string | null;
  paidAt?: string | null;
  createdAt: string;
  updatedAt: string;
}

export interface RentalPaymentStatusResult {
  manifestId: string;
  billId: string;
  status: string;
  message?: string | null;
  cbsReference?: string | null;
  confirmationCode?: string | null;
  amountDue: number;
  paidAmount?: number | null;
  paidAt?: string | null;
  updatedAt: string;
}

export interface ResourceMobilizationEmployeeSearchResult {
  id: string;
  employeeReference: string;
  fullName: string;
  phoneNumber?: string | null;
  branchCode?: string | null;
  branchName?: string | null;
  departmentName?: string | null;
  positionName?: string | null;
  classification?: string | null;
  isActive: boolean;
  hasExistingRegistration: boolean;
  existingMonthlyTargetAmount?: number | null;
  existingNewAccountCount?: number | null;
}

export interface ResourceMobilizationTransactionLookupRequest {
  transactionReferenceNo?: string | null;
  accountNumber?: string | null;
  fromDate?: string | null;
  toDate?: string | null;
  limit?: number;
}

export interface ResourceMobilizationTransactionResult {
  transactionReferenceNo: string;
  depositBranchCode: string;
  depositBranchName: string;
  accountNumber: string;
  currency: string;
  amount: number;
  valueDate: string;
  customerNumber?: string | null;
  customerName: string;
  accountClass?: string | null;
  suggestedProductType: 'DEMAND' | 'SAVING' | 'IFB' | string;
  rawPayload: string;
  alreadyRegistered: boolean;
  existingRecordId?: number | null;
  existingRegistrationReference?: string | null;
  existingStatus?: string | null;
  existingEmployeeReference?: string | null;
  existingEmployeeFullName?: string | null;
}

export interface ResourceMobilizationSubmitRequest {
  employeeDirectoryEntryId?: string | null;
  employeeDirectoryEntryIds?: string[] | null;
  isJointRegistration?: boolean;
  monthlyTargetAmount: number;
  depositProductType: 'DEMAND' | 'SAVING' | 'IFB' | string;
  newAccountCount: number;
  transactionReferenceNo: string;
  accountNumber: string;
  depositorCustomerName?: string | null;
}

export interface ResourceMobilizationRecord {
  id: number;
  registrationReference: string;
  registrationBatchReference: string;
  isJointRegistration: boolean;
  jointParticipantCount: number;
  jointSequenceNumber: number;
  employeeReference: string;
  employeeFullName: string;
  employeePhoneNumber?: string | null;
  employeeBranchCode?: string | null;
  employeeBranchName?: string | null;
  employeeDepartmentName?: string | null;
  employeePositionName?: string | null;
  employeeClassification?: string | null;
  monthlyTargetAmount: number;
  depositProductType: 'DEMAND' | 'SAVING' | 'IFB' | string;
  sourceTransactionAmount: number;
  totalDepositMobilized: number;
  newAccountCount: number;
  depositorCustomerName: string;
  depositorCustomerNumber?: string | null;
  depositorAccountNumber: string;
  depositorAccountClass?: string | null;
  transactionReferenceNo: string;
  depositBranchCode: string;
  depositBranchName?: string | null;
  transactionCurrency: string;
  transactionValueDate: string;
  status: string;
  makerUserName?: string | null;
  makerBranchCode?: string | null;
  makerBranchName?: string | null;
  checkerUserName?: string | null;
  checkerBranchCode?: string | null;
  checkerBranchName?: string | null;
  checkerComment?: string | null;
  rejectionReason?: string | null;
  createdAt: string;
  updatedAt: string;
  approvedAt?: string | null;
  rejectedAt?: string | null;
}

export interface ResourceMobilizationReportQuery {
  search?: string;
  status?: string;
  depositProductType?: string;
  fromDate?: string;
  toDate?: string;
  page?: number;
  pageSize?: number;
  sortBy?: string;
  sortDirection?: 'asc' | 'desc';
}

export interface ResourceMobilizationReportResponse {
  page: number;
  pageSize: number;
  totalRecords: number;
  totalPages: number;
  items: ResourceMobilizationRecord[];
}

export interface ResourceMobilizationStatusBreakdown {
  total: number;
  pending: number;
  approved: number;
  rejected: number;
  approvedAmount: number;
  distinctEmployees: number;
}

export interface ResourceMobilizationLeaderboardItem {
  employeeReference: string;
  employeeFullName: string;
  employeeDepartmentName?: string | null;
  employeeBranchCode?: string | null;
  employeeBranchName?: string | null;
  totalAmount: number;
  transactionCount: number;
  totalNewAccounts: number;
}

export interface ResourceMobilizationDashboardPeriod {
  rangeStartUtc: string;
  rangeEndUtc: string;
  totals: ResourceMobilizationStatusBreakdown;
  topMobilizers: ResourceMobilizationLeaderboardItem[];
}

export interface ResourceMobilizationDashboardStats {
  scope: string;
  branchCode?: string | null;
  today: ResourceMobilizationDashboardPeriod;
  thisWeek: ResourceMobilizationDashboardPeriod;
  thisMonth: ResourceMobilizationDashboardPeriod;
}
