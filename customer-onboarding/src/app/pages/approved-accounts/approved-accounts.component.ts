import { Component, OnInit } from '@angular/core';
import { DomSanitizer, SafeResourceUrl } from '@angular/platform-browser';
import {
  AccountOpeningDetails,
  AdditionalCustomerDetails,
  ApprovalRecord,
  CustomerProfileSnapshot,
  SupportingDocument
} from 'src/app/models/onboarding.models';
import { ApprovalWorkflowService } from 'src/app/services/approval-workflow.service';
import { AuthService } from 'src/app/services/auth.service';
import { CustomerOnboardingService } from 'src/app/services/customer-onboarding.service';
import { ToastService } from 'src/app/services/toast.service';
import { VerifiedProfileExportService } from 'src/app/services/verified-profile-export.service';

@Component({
  selector: 'app-approved-accounts',
  templateUrl: './approved-accounts.component.html',
  styleUrls: ['./approved-accounts.component.css']
})
export class ApprovedAccountsComponent implements OnInit {
  readonly pageSizeOptions = [10, 20, 50, 100, -1];
  readonly statusOptions = ['ALL', 'PENDING_KYC_AUTHORIZATION', 'KYC_PROCESSING', 'KYC_APPROVED', 'KYC_REJECTED', 'FULFILLMENT_FAILED', 'DUPLICATE_CIF_BLOCKED', 'PENDING_CHECKER_APPROVAL', 'ACCOUNT_CREATED', 'KYC_REVIEWED', 'FAILED', 'REJECTED'];

  records: ApprovalRecord[] = [];
  selectedRecord: ApprovalRecord | null = null;
  loading = false;
  pageError: string | null = null;
  searchTerm = '';
  statusFilter = 'ALL';
  currentPage = 1;
  pageSize = 10;
  sortField: 'submittedAtUtc' | 'reviewedAtUtc' | 'customerName' | 'customerNumber' | 'accountNumber' = 'submittedAtUtc';
  sortDirection: 'asc' | 'desc' = 'desc';

  selectedSnapshot: CustomerProfileSnapshot | null = null;
  selectedAdditional: AdditionalCustomerDetails | null = null;
  selectedAccountDetails: AccountOpeningDetails | null = null;
  selectedDocuments: SupportingDocument[] = [];
  nidPhotoPreview = '';
  uploadedPhotoPreview = '';
  signaturePreview = '';
  downloadingProfile = false;
  viewerTitle = '';
  viewerUrl = '';
  viewerMimeType = '';
  viewerResourceUrl: SafeResourceUrl | null = null;

  constructor(
    private workflow: ApprovalWorkflowService,
    private auth: AuthService,
    private onboarding: CustomerOnboardingService,
    private exportService: VerifiedProfileExportService,
    private toast: ToastService,
    private sanitizer: DomSanitizer
  ) {}

  ngOnInit(): void {
    this.loadRecords();
  }

  get isMakerView(): boolean {
    return this.auth.getCurrentUser()?.role === 'MAKER';
  }

  get pageTitle(): string {
    return this.isMakerView ? 'View your onboarding requests' : 'View completed account openings';
  }

  get pageCopy(): string {
    return this.isMakerView
      ? 'Track pending and completed onboarding requests, then open the full record with assets and documents whenever needed.'
      : 'Search completed records for your branch and open details only when needed.';
  }

  loadRecords(): void {
    this.loading = true;
    this.pageError = null;

    const request$ = this.isMakerView
      ? this.workflow.getMySubmissions()
      : this.workflow.getCompletedRecords();

    request$.subscribe({
      next: (records) => {
        this.loading = false;
        this.records = records;
        this.currentPage = 1;
        this.selectedRecord = null;
      },
      error: (error: any) => {
        this.loading = false;
        this.pageError = error?.error?.message || error?.message || 'Failed to load onboarding records.';
        this.toast.error('Load failed', this.pageError || 'Load failed.');
      }
    });
  }

  updateSearch(value: string): void {
    this.searchTerm = value;
    this.currentPage = 1;
  }

  updateStatusFilter(value: string): void {
    this.statusFilter = value || 'ALL';
    this.currentPage = 1;
  }

  updatePageSize(value: string): void {
    const parsed = Number(value);
    this.pageSize = Number.isFinite(parsed) ? parsed : 10;
    this.currentPage = 1;
  }

  openDetails(record: ApprovalRecord): void {
    this.selectedRecord = record;
    this.selectedSnapshot = this.parseJson<CustomerProfileSnapshot>(record.snapshotJson);
    this.selectedAdditional = this.parseJson<AdditionalCustomerDetails>(record.additionalDetailsJson);
    this.selectedAccountDetails = this.parseJson<AccountOpeningDetails>(record.accountDetailsJson);
    this.selectedDocuments = this.parseJson<SupportingDocument[]>(record.documentsJson)
      || this.selectedAccountDetails?.uploadedDocuments
      || [];
    this.selectedDocuments = this.selectedDocuments.map((document) => ({
      ...document,
      mimeType: this.onboarding.resolveDocumentMimeType(document.mimeType, document.fileName)
    }));
    this.uploadedPhotoPreview = this.selectedAccountDetails?.imageBase64
      ? `data:image/${(this.selectedAccountDetails.imageFileType || 'jpeg').toLowerCase()};base64,${this.selectedAccountDetails.imageBase64}`
      : '';
    this.signaturePreview = this.selectedAccountDetails?.signatureBase64
      ? `data:image/${(this.selectedAccountDetails.signatureFileType || 'jpeg').toLowerCase()};base64,${this.selectedAccountDetails.signatureBase64}`
      : '';
    void this.loadNidPhotoPreview();
  }

  closeDetails(): void {
    this.selectedRecord = null;
    this.selectedSnapshot = null;
    this.selectedAdditional = null;
    this.selectedAccountDetails = null;
    this.selectedDocuments = [];
    this.nidPhotoPreview = '';
    this.uploadedPhotoPreview = '';
    this.signaturePreview = '';
    this.closeViewer();
  }

  async downloadVerifiedProfile(): Promise<void> {
    if (!this.selectedSnapshot) {
      return;
    }

    this.downloadingProfile = true;
    try {
      await this.exportService.downloadProfile(this.selectedSnapshot, this.selectedAdditional);
      this.toast.success('Verified profile ready', 'The saved verified profile was downloaded successfully.');
    } finally {
      this.downloadingProfile = false;
    }
  }

  sortBy(field: 'submittedAtUtc' | 'reviewedAtUtc' | 'customerName' | 'customerNumber' | 'accountNumber'): void {
    if (this.sortField === field) {
      this.sortDirection = this.sortDirection === 'asc' ? 'desc' : 'asc';
    } else {
      this.sortField = field;
      this.sortDirection = field === 'submittedAtUtc' || field === 'reviewedAtUtc' ? 'desc' : 'asc';
    }
    this.currentPage = 1;
  }

  changePage(page: number): void {
    this.currentPage = Math.max(1, Math.min(page, this.totalPages));
  }

  openAssetViewer(title: string, url: string, mimeType = 'image/jpeg'): void {
    if (!url) {
      return;
    }

    this.viewerTitle = title;
    this.viewerUrl = url;
    this.viewerMimeType = mimeType;
    this.viewerResourceUrl = this.sanitizer.bypassSecurityTrustResourceUrl(url);
  }

  closeViewer(): void {
    this.viewerTitle = '';
    this.viewerUrl = '';
    this.viewerMimeType = '';
    this.viewerResourceUrl = null;
  }

  isViewerOpen(): boolean {
    return !!this.viewerUrl;
  }

  openDocumentViewer(file: SupportingDocument): void {
    const url = this.getDocumentUrl(file);
    this.openAssetViewer(file.displayName || file.fileName, url, file.mimeType || 'application/octet-stream');
  }

  getDocumentUrl(file: SupportingDocument): string {
    return this.onboarding.buildDocumentDownloadUrl(file);
  }

  downloadDocument(file: SupportingDocument): void {
    const url = this.getDocumentUrl(file);
    if (!url) {
      return;
    }

    const link = document.createElement('a');
    link.href = url;
    link.download = file.fileName || `${file.category}.bin`;
    link.click();
  }

  isImageMimeType(mimeType: string | null | undefined): boolean {
    return this.onboarding.resolveDocumentMimeType(mimeType).startsWith('image/');
  }

  isPdfMimeType(mimeType: string | null | undefined): boolean {
    return this.onboarding.resolveDocumentMimeType(mimeType).includes('pdf');
  }

  getStatusLabel(status: string): string {
    switch ((status || '').toUpperCase()) {
      case 'PENDING_CHECKER_APPROVAL':
        return 'Pending approval';
      case 'PENDING_KYC_AUTHORIZATION':
        return 'Pending KYC authorization';
      case 'KYC_PROCESSING':
        return 'KYC fulfillment in progress';
      case 'ACCOUNT_CREATED':
        return 'Account created';
      case 'KYC_APPROVED':
        return 'KYC approved';
      case 'KYC_REVIEWED':
        return 'KYC reviewed';
      case 'KYC_REJECTED':
        return 'KYC rejected';
      case 'FULFILLMENT_FAILED':
        return 'KYC fulfillment needs attention';
      case 'DUPLICATE_CIF_BLOCKED':
        return 'Duplicate CIF blocked';
      case 'REJECTED':
        return 'Rejected';
      case 'FAILED':
        return 'Needs attention';
      default:
        return status || 'Pending';
    }
  }

  get fundingSourceLabel(): string {
    if (!this.selectedRecord) {
      return 'Cash';
    }

    switch (this.selectedRecord.fundingSourceType) {
      case 'ACCOUNT':
        return 'Other account';
      case 'GL':
        return 'General ledger';
      default:
        return 'Cash';
    }
  }

  get filteredRecords(): ApprovalRecord[] {
    const term = this.searchTerm.trim().toLowerCase();
    const status = this.statusFilter.toUpperCase();

    const result = this.records.filter((record) => {
      const matchesSearch = !term || [
        record.customerName,
        record.customerNumber,
        record.accountNumber || '',
        record.accountClass,
        record.branchCode,
        record.makerFullName,
        record.makerUsername,
        record.checkerFullName || '',
        record.caseReference,
        this.getStatusLabel(record.status)
      ].some((value) => (value || '').toLowerCase().includes(term));

      const matchesStatus = status === 'ALL' || (record.status || '').toUpperCase() === status;
      return matchesSearch && matchesStatus;
    });

    return result.sort((left, right) => this.compare(left, right));
  }

  get pagedRecords(): ApprovalRecord[] {
    if (this.pageSize === -1) {
      return this.filteredRecords;
    }

    const start = (this.currentPage - 1) * this.pageSize;
    return this.filteredRecords.slice(start, start + this.pageSize);
  }

  get totalPages(): number {
    if (this.pageSize === -1) {
      return 1;
    }

    return Math.max(1, Math.ceil(this.filteredRecords.length / this.pageSize));
  }

  private compare(left: ApprovalRecord, right: ApprovalRecord): number {
    const leftValue = this.getSortValue(left);
    const rightValue = this.getSortValue(right);
    const result = leftValue.localeCompare(rightValue, undefined, { numeric: true, sensitivity: 'base' });
    return this.sortDirection === 'asc' ? result : -result;
  }

  private getSortValue(record: ApprovalRecord): string {
    switch (this.sortField) {
      case 'customerName':
        return record.customerName || '';
      case 'customerNumber':
        return record.customerNumber || '';
      case 'accountNumber':
        return record.accountNumber || '';
      case 'reviewedAtUtc':
        return record.reviewedAtUtc || '';
      default:
        return record.submittedAtUtc || '';
    }
  }

  private parseJson<T>(raw: string | undefined | null): T | null {
    if (!raw) {
      return null;
    }

    try {
      return this.normalizeKeys(JSON.parse(raw)) as T;
    } catch {
      return null;
    }
  }

  private normalizeKeys(value: unknown): unknown {
    if (Array.isArray(value)) {
      return value.map((item) => this.normalizeKeys(item));
    }

    if (!value || typeof value !== 'object') {
      return value;
    }

    return Object.entries(value as Record<string, unknown>).reduce<Record<string, unknown>>((result, [key, entryValue]) => {
      const normalizedKey = key ? key.charAt(0).toLowerCase() + key.slice(1) : key;
      result[normalizedKey] = this.normalizeKeys(entryValue);
      return result;
    }, {});
  }

  private async loadNidPhotoPreview(): Promise<void> {
    this.nidPhotoPreview = await this.onboarding.resolveIdentityPhotoPreview(this.selectedSnapshot?.photoBase64);
  }
}
