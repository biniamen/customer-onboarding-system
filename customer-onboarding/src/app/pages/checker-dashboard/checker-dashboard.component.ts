import { Component, OnInit } from '@angular/core';
import { DomSanitizer, SafeResourceUrl } from '@angular/platform-browser';
import { AccountOpeningDetails, AdditionalCustomerDetails, ApprovalRecord, CustomerProfileSnapshot, SupportingDocument } from 'src/app/models/onboarding.models';
import { ApprovalWorkflowService } from 'src/app/services/approval-workflow.service';
import { CustomerOnboardingService } from 'src/app/services/customer-onboarding.service';
import { ToastService } from 'src/app/services/toast.service';
import { VerifiedProfileExportService } from 'src/app/services/verified-profile-export.service';

@Component({
  selector: 'app-checker-dashboard',
  templateUrl: './checker-dashboard.component.html',
  styleUrls: ['./checker-dashboard.component.css']
})
export class CheckerDashboardComponent implements OnInit {
  readonly pageSizeOptions = [10, 20, 50, 100, -1];
  records: ApprovalRecord[] = [];
  selectedRecord: ApprovalRecord | null = null;
  loading = false;
  acting = false;
  pageError: string | null = null;
  approvalMessage: string | null = null;
  checkerComment = '';
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

  queueFilter = '';
  currentPage = 1;
  pageSize = 10;

  constructor(
    private workflow: ApprovalWorkflowService,
    private onboarding: CustomerOnboardingService,
    private exportService: VerifiedProfileExportService,
    private toast: ToastService,
    private sanitizer: DomSanitizer
  ) {}

  ngOnInit(): void {
    this.loadPending();
  }

  loadPending(): void {
    this.loading = true;
    this.pageError = null;

    this.workflow.getPendingApprovals().subscribe({
      next: (records) => {
        this.loading = false;
        this.records = records;
        this.currentPage = 1;
        this.selectRecord(records[0] || null);
        if (records.length) {
          this.toast.info('Queue refreshed', `${records.length} pending case(s) available for your branch.`);
        }
      },
      error: (error: any) => {
        this.loading = false;
        this.pageError = error?.error?.message || error?.message || 'Failed to load pending approvals.';
        this.toast.error('Queue load failed', this.pageError || 'Queue load failed.');
      }
    });
  }

  selectRecord(record: ApprovalRecord | null): void {
    this.selectedRecord = record;
    this.approvalMessage = null;
    this.pageError = null;
    this.checkerComment = '';
    this.selectedSnapshot = this.parseJson<CustomerProfileSnapshot>(record?.snapshotJson);
    this.selectedAdditional = this.parseJson<AdditionalCustomerDetails>(record?.additionalDetailsJson);
    this.selectedAccountDetails = this.parseJson<AccountOpeningDetails>(record?.accountDetailsJson);
    this.selectedDocuments = this.parseJson<SupportingDocument[]>(record?.documentsJson)
      || this.selectedAccountDetails?.uploadedDocuments
      || [];
    this.selectedDocuments = this.selectedDocuments.map((document) => ({
      ...document,
      mimeType: this.onboarding.resolveDocumentMimeType(document.mimeType, document.fileName)
    }));
    void this.loadNidPhotoPreview();
    this.uploadedPhotoPreview = this.selectedAccountDetails?.imageBase64
      ? `data:image/${(this.selectedAccountDetails.imageFileType || 'jpeg').toLowerCase()};base64,${this.selectedAccountDetails.imageBase64}`
      : '';
    this.signaturePreview = this.selectedAccountDetails?.signatureBase64
      ? `data:image/${(this.selectedAccountDetails.signatureFileType || 'jpeg').toLowerCase()};base64,${this.selectedAccountDetails.signatureBase64}`
      : '';
  }

  approve(): void {
    if (!this.selectedRecord) {
      return;
    }

    this.acting = true;
    this.pageError = null;
    this.approvalMessage = null;

    this.workflow.approve(this.selectedRecord.id, this.checkerComment).subscribe({
      next: (record) => {
        this.acting = false;
        this.approvalMessage = record.accountNumber
          ? `Account ${record.accountNumber} created successfully.`
          : 'Approval completed.';
        this.records = this.records.filter((item) => item.id !== record.id);
        this.normalizePage();
        this.selectRecord(this.pagedRecords[0] || this.records[0] || null);
        this.toast.success('Approved', this.approvalMessage);
      },
      error: (error: any) => {
        this.acting = false;
        this.pageError = error?.error?.message || error?.message || 'Approval failed.';
        this.toast.error('Approval failed', this.pageError || 'Approval failed.');
      }
    });
  }

  reject(): void {
    if (!this.selectedRecord || !this.checkerComment.trim()) {
      this.pageError = 'Please write a checker remark before rejecting this case.';
      this.toast.error('Remark required', this.pageError);
      return;
    }

    this.acting = true;
    this.pageError = null;
    this.approvalMessage = null;

    this.workflow.reject(this.selectedRecord.id, this.checkerComment).subscribe({
      next: (record) => {
        this.acting = false;
        this.approvalMessage = `Case ${record.caseReference} rejected successfully.`;
        this.records = this.records.filter((item) => item.id !== record.id);
        this.normalizePage();
        this.selectRecord(this.pagedRecords[0] || this.records[0] || null);
        this.toast.success('Rejected', this.approvalMessage);
      },
      error: (error: any) => {
        this.acting = false;
        this.pageError = error?.error?.message || error?.message || 'Rejection failed.';
        this.toast.error('Rejection failed', this.pageError || 'Rejection failed.');
      }
    });
  }

  get filteredRecords(): ApprovalRecord[] {
    const keyword = this.queueFilter.trim().toLowerCase();
    if (!keyword) {
      return this.records;
    }

    return this.records.filter((record) =>
      record.caseReference.toLowerCase().includes(keyword) ||
      record.customerNumber.toLowerCase().includes(keyword) ||
      record.customerName.toLowerCase().includes(keyword) ||
      record.makerUsername.toLowerCase().includes(keyword)
    );
  }

  get totalPages(): number {
    if (this.pageSize === -1) {
      return 1;
    }

    return Math.max(1, Math.ceil(this.filteredRecords.length / this.pageSize));
  }

  get pagedRecords(): ApprovalRecord[] {
    if (this.pageSize === -1) {
      return this.filteredRecords;
    }

    const start = (this.currentPage - 1) * this.pageSize;
    return this.filteredRecords.slice(start, start + this.pageSize);
  }

  changePage(page: number): void {
    this.currentPage = Math.min(Math.max(page, 1), this.totalPages);
    if (this.selectedRecord && this.pagedRecords.some((record) => record.id === this.selectedRecord?.id)) {
      return;
    }

    this.selectRecord(this.pagedRecords[0] || null);
  }

  updateFilter(value: string): void {
    this.queueFilter = value;
    this.currentPage = 1;
    this.selectRecord(this.pagedRecords[0] || this.filteredRecords[0] || null);
  }

  updatePageSize(value: string): void {
    const parsed = Number(value);
    this.pageSize = Number.isFinite(parsed) ? parsed : 10;
    this.currentPage = 1;
    this.selectRecord(this.pagedRecords[0] || this.filteredRecords[0] || null);
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

  downloadDocument(file: SupportingDocument): void {
    const url = this.onboarding.buildDocumentDownloadUrl(file);
    if (!url) {
      return;
    }

    const link = document.createElement('a');
    link.href = url;
    link.download = file.fileName || `${file.category}.bin`;
    link.click();
  }

  isViewerOpen(): boolean {
    return !!this.viewerUrl;
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

  closeAssetViewer(): void {
    this.viewerTitle = '';
    this.viewerUrl = '';
    this.viewerMimeType = '';
    this.viewerResourceUrl = null;
  }

  openDocumentViewer(file: SupportingDocument): void {
    const url = this.getDocumentUrl(file);
    this.openAssetViewer(file.displayName || file.fileName, url, file.mimeType || 'application/octet-stream');
  }

  getDocumentUrl(file: SupportingDocument): string {
    return this.onboarding.buildDocumentDownloadUrl(file);
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
      case 'ACCOUNT_CREATED':
        return 'Account created';
      case 'REJECTED':
        return 'Rejected';
      case 'FAILED':
        return 'Needs attention';
      default:
        return status || 'Pending';
    }
  }

  private normalizePage(): void {
    this.currentPage = Math.min(this.currentPage, this.totalPages);
    if (this.currentPage < 1) {
      this.currentPage = 1;
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
