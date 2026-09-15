import { Component, OnInit } from '@angular/core';
import { AccountOpeningDetails, AdditionalCustomerDetails, ApprovalRecord, CustomerProfileSnapshot, SupportingDocument } from 'src/app/models/onboarding.models';
import { ApprovalWorkflowService } from 'src/app/services/approval-workflow.service';
import { CustomerOnboardingService } from 'src/app/services/customer-onboarding.service';
import { ToastService } from 'src/app/services/toast.service';

interface ScreeningMatch {
  type: string;
  severity: string;
  summary: string;
  source?: string | null;
  reference?: string | null;
  restrictive: boolean;
}

@Component({
  selector: 'app-kyc-authorization',
  templateUrl: './kyc-authorization.component.html'
})
export class KycAuthorizationComponent implements OnInit {
  readonly pageSizeOptions = [10, 20, 50, 100, -1];
  records: ApprovalRecord[] = [];
  selectedRecord: ApprovalRecord | null = null;
  selectedSnapshot: CustomerProfileSnapshot | null = null;
  selectedAdditional: AdditionalCustomerDetails | null = null;
  selectedAccount: AccountOpeningDetails | null = null;
  selectedDocuments: SupportingDocument[] = [];
  screeningMatches: ScreeningMatch[] = [];
  nidPhoto = '';
  customerPhoto = '';
  signature = '';
  search = '';
  pageSize = 10;
  page = 1;
  kycComment = '';
  loading = false;
  acting = false;
  pageError = '';

  constructor(
    private workflow: ApprovalWorkflowService,
    private onboarding: CustomerOnboardingService,
    private toast: ToastService
  ) {}

  ngOnInit(): void {
    this.load();
  }

  load(): void {
    this.loading = true;
    this.pageError = '';
    this.workflow.getKycPendingApprovals().subscribe({
      next: (records) => {
        this.loading = false;
        this.records = records;
        this.page = 1;
        this.select(this.pagedRecords[0] || null);
      },
      error: (error: any) => {
        this.loading = false;
        this.pageError = error?.error?.message || error?.message || 'Unable to load the KYC authorization queue.';
      }
    });
  }

  select(record: ApprovalRecord | null): void {
    this.selectedRecord = record;
    this.kycComment = '';
    this.selectedSnapshot = this.parse<CustomerProfileSnapshot>(record?.snapshotJson);
    this.selectedAdditional = this.parse<AdditionalCustomerDetails>(record?.additionalDetailsJson);
    this.selectedAccount = this.parse<AccountOpeningDetails>(record?.accountDetailsJson);
    this.selectedDocuments = this.parse<SupportingDocument[]>(record?.documentsJson) || this.selectedAccount?.uploadedDocuments || [];
    this.screeningMatches = this.parse<{ matches?: ScreeningMatch[] }>(record?.screeningDetailsJson)?.matches || [];
    this.nidPhoto = '';
    this.customerPhoto = this.selectedAccount?.imageBase64 ? `data:image/${(this.selectedAccount.imageFileType || 'jpeg').toLowerCase()};base64,${this.selectedAccount.imageBase64}` : '';
    this.signature = this.selectedAccount?.signatureBase64 ? `data:image/${(this.selectedAccount.signatureFileType || 'jpeg').toLowerCase()};base64,${this.selectedAccount.signatureBase64}` : '';
    void this.loadNidPhoto();
  }

  approve(): void {
    if (!this.selectedRecord) return;
    this.act(this.workflow.kycApprove(this.selectedRecord.id, this.kycComment), 'KYC authorization completed.');
  }

  reject(): void {
    if (!this.selectedRecord) return;
    if (!this.kycComment.trim()) {
      this.pageError = 'Enter a KYC rejection reason before rejecting this request.';
      return;
    }
    this.act(this.workflow.kycReject(this.selectedRecord.id, this.kycComment), 'KYC request rejected.');
  }

  openDocument(document: SupportingDocument): void {
    const url = this.onboarding.buildDocumentDownloadUrl(document);
    if (url) window.open(url, '_blank', 'noopener');
  }

  get isRestrictivelyBlocked(): boolean {
    return !!this.selectedRecord?.hasRestrictiveScreeningMatch;
  }

  get filteredRecords(): ApprovalRecord[] {
    const search = this.search.trim().toLowerCase();
    if (!search) return this.records;
    return this.records.filter(record => [record.caseReference, record.customerName, record.customerNumber, record.makerUsername, record.branchCode]
      .some(value => (value || '').toLowerCase().includes(search)));
  }

  get totalPages(): number {
    return this.pageSize === -1 ? 1 : Math.max(1, Math.ceil(this.filteredRecords.length / this.pageSize));
  }

  get pagedRecords(): ApprovalRecord[] {
    if (this.pageSize === -1) return this.filteredRecords;
    const start = (this.page - 1) * this.pageSize;
    return this.filteredRecords.slice(start, start + this.pageSize);
  }

  changePage(nextPage: number): void {
    this.page = Math.max(1, Math.min(nextPage, this.totalPages));
    this.select(this.pagedRecords[0] || null);
  }

  updateSearch(value: string): void {
    this.search = value;
    this.page = 1;
    this.select(this.pagedRecords[0] || null);
  }

  updatePageSize(value: string): void {
    this.pageSize = Number(value) || 10;
    this.page = 1;
    this.select(this.pagedRecords[0] || null);
  }

  private act(action: any, successMessage: string): void {
    this.acting = true;
    this.pageError = '';
    action.subscribe({
      next: (record: ApprovalRecord) => {
        this.acting = false;
        if (record.status === 'KYC_APPROVED' || record.status === 'KYC_REJECTED') {
          this.records = this.records.filter(item => item.id !== record.id);
        } else {
          this.records = this.records.map(item => item.id === record.id ? record : item);
          this.pageError = record.lastError || 'KYC fulfilment needs attention. The request remains available for retry.';
        }
        this.select(this.pagedRecords[0] || this.records[0] || null);
        this.toast.success('KYC updated', successMessage);
      },
      error: (error: any) => {
        this.acting = false;
        this.pageError = error?.error?.message || error?.message || 'KYC action failed.';
        this.toast.error('KYC action failed', this.pageError);
      }
    });
  }

  private parse<T>(raw: string | undefined | null): T | null {
    if (!raw) return null;
    try { return this.normalize(JSON.parse(raw)) as T; } catch { return null; }
  }

  private normalize(value: any): any {
    if (Array.isArray(value)) return value.map(item => this.normalize(item));
    if (!value || typeof value !== 'object') return value;
    return Object.entries(value).reduce((result: any, [key, entry]) => {
      result[key.charAt(0).toLowerCase() + key.slice(1)] = this.normalize(entry);
      return result;
    }, {});
  }

  private async loadNidPhoto(): Promise<void> {
    this.nidPhoto = await this.onboarding.resolveIdentityPhotoPreview(this.selectedSnapshot?.photoBase64);
  }
}
