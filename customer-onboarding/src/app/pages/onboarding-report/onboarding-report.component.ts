import { Component, OnInit } from '@angular/core';
import { DomSanitizer, SafeResourceUrl } from '@angular/platform-browser';
import { firstValueFrom } from 'rxjs';
import {
  AccountOpeningDetails,
  AdditionalCustomerDetails,
  ApprovalRecord,
  CustomerProfileSnapshot,
  OnboardingBranchStats,
  OnboardingDashboardStats,
  OnboardingReportQuery,
  OnboardingReportResponse,
  SupportingDocument
} from 'src/app/models/onboarding.models';
import { ApprovalWorkflowService } from 'src/app/services/approval-workflow.service';
import { AuthService } from 'src/app/services/auth.service';
import { CustomerOnboardingService } from 'src/app/services/customer-onboarding.service';
import { ToastService } from 'src/app/services/toast.service';
import { VerifiedProfileExportService } from 'src/app/services/verified-profile-export.service';

@Component({
  selector: 'app-onboarding-report',
  templateUrl: './onboarding-report.component.html',
  styleUrls: ['./onboarding-report.component.css']
})
export class OnboardingReportComponent implements OnInit {
  readonly pageSizeOptions = [10, 20, 50, 100, -1];
  readonly exportFilePrefix = 'onboarding-report';

  loading = false;
  loadingDashboard = false;
  exportBusy = false;
  pageError: string | null = null;
  dashboardStats: OnboardingDashboardStats | null = null;
  selectedRecord: ApprovalRecord | null = null;
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

  searchTerm = '';
  statusFilter = '';
  fromDate = '';
  toDate = '';
  pageSize = 10;
  currentPage = 1;
  totalPages = 1;
  totalRecords = 0;

  branchSearchTerm = '';
  branchPageSize = 10;
  branchCurrentPage = 1;

  records: ApprovalRecord[] = [];

  constructor(
    private workflow: ApprovalWorkflowService,
    private auth: AuthService,
    private onboarding: CustomerOnboardingService,
    private exportService: VerifiedProfileExportService,
    private toast: ToastService,
    private sanitizer: DomSanitizer
  ) {}

  ngOnInit(): void {
    if (this.isKycUnit) {
      this.statusFilter = '';
    }

    this.refreshAll();
  }

  get isKycUnit(): boolean {
    return this.auth.getCurrentUser()?.role === 'KYC_UNIT';
  }

  get statusOptions(): string[] {
    return [
      '', 'PENDING_KYC_AUTHORIZATION', 'KYC_PROCESSING', 'KYC_APPROVED', 'KYC_REJECTED',
      'FULFILLMENT_FAILED', 'DUPLICATE_CIF_BLOCKED', 'PENDING_CHECKER_APPROVAL',
      'ACCOUNT_CREATED', 'KYC_REVIEWED', 'FAILED', 'REJECTED'
    ];
  }

  get summaryRangeLabel(): string {
    return this.fromDate || this.toDate ? 'Selected range' : 'Today';
  }

  get summaryRangeText(): string {
    if (this.dashboardStats) {
      const start = this.dashboardStats.rangeStartUtc ? new Date(this.dashboardStats.rangeStartUtc) : null;
      const end = this.dashboardStats.rangeEndUtc ? new Date(this.dashboardStats.rangeEndUtc) : null;
      if (start && end) {
        const endInclusive = new Date(end.getTime() - 1);
        return `${start.toLocaleDateString()} - ${endInclusive.toLocaleDateString()}`;
      }
    }

    return 'Current business day';
  }

  get branchStats(): OnboardingBranchStats[] {
    return this.dashboardStats?.branches || [];
  }

  get filteredBranchStats(): OnboardingBranchStats[] {
    const keyword = this.branchSearchTerm.trim().toLowerCase();
    if (!keyword) {
      return this.branchStats;
    }

    return this.branchStats.filter((branch) => `${branch.branchCode} ${branch.branchName}`.toLowerCase().includes(keyword));
  }

  get branchTotalPages(): number {
    if (this.branchPageSize === -1) {
      return 1;
    }

    return Math.max(1, Math.ceil(this.filteredBranchStats.length / this.branchPageSize));
  }

  get pagedBranchStats(): OnboardingBranchStats[] {
    const items = this.filteredBranchStats;
    if (this.branchPageSize === -1) {
      return items;
    }

    const safePage = Math.min(this.branchCurrentPage, this.branchTotalPages);
    const startIndex = (safePage - 1) * this.branchPageSize;
    return items.slice(startIndex, startIndex + this.branchPageSize);
  }

  refreshAll(): void {
    this.loadReport();
    this.loadDashboard();
  }

  loadReport(): void {
    this.loading = true;
    this.pageError = null;

    this.workflow.getReport(this.buildReportQuery()).subscribe({
      next: (response: OnboardingReportResponse) => {
        this.loading = false;
        this.records = response.items || [];
        this.totalPages = response.totalPages || 1;
        this.totalRecords = response.totalRecords || 0;
        this.currentPage = response.page || 1;
        if (this.selectedRecord && !this.records.some((item) => item.id === this.selectedRecord?.id)) {
          this.closeDetails();
        }
      },
      error: (error: any) => {
        this.loading = false;
        this.pageError = error?.error?.message || error?.message || 'Unable to load onboarding report data.';
        this.toast.error('Report load failed', this.pageError || 'Report load failed.');
      }
    });
  }

  loadDashboard(): void {
    this.loadingDashboard = true;

    this.workflow.getDashboardStats(this.buildDashboardQuery()).subscribe({
      next: (stats) => {
        this.loadingDashboard = false;
        this.dashboardStats = stats;
        this.syncBranchPagination();
      },
      error: (error: any) => {
        this.loadingDashboard = false;
        this.dashboardStats = null;
        if (error?.error?.message) {
          this.toast.error('Summary load failed', error.error.message);
        }
      }
    });
  }

  applyFilters(): void {
    this.currentPage = 1;
    this.branchCurrentPage = 1;
    this.loadReport();
    this.loadDashboard();
  }

  clearFilters(): void {
    this.searchTerm = '';
    this.statusFilter = '';
    this.fromDate = '';
    this.toDate = '';
    this.pageSize = 10;
    this.currentPage = 1;
    this.branchSearchTerm = '';
    this.branchPageSize = 10;
    this.branchCurrentPage = 1;
    this.refreshAll();
  }

  updatePageSize(value: string | number): void {
    const parsed = Number(value);
    this.pageSize = Number.isFinite(parsed) ? parsed : 10;
    this.currentPage = 1;
    this.loadReport();
  }

  changePage(page: number): void {
    if (page < 1 || page > this.totalPages || page === this.currentPage) {
      return;
    }

    this.currentPage = page;
    this.loadReport();
  }

  updateBranchPageSize(value: string | number): void {
    const parsed = Number(value);
    this.branchPageSize = Number.isFinite(parsed) ? parsed : 10;
    this.branchCurrentPage = 1;
    this.syncBranchPagination();
  }

  changeBranchPage(page: number): void {
    if (page < 1 || page > this.branchTotalPages || page === this.branchCurrentPage) {
      return;
    }

    this.branchCurrentPage = page;
  }

  onBranchSearchChange(): void {
    this.branchCurrentPage = 1;
    this.syncBranchPagination();
  }

  async openDetails(record: ApprovalRecord): Promise<void> {
    let selectedRecord = record;

    try {
      selectedRecord = await firstValueFrom(this.workflow.getRecord(selectedRecord.id));
    } catch (error: any) {
      this.toast.error('Record details unavailable', error?.error?.message || error?.message || 'Unable to load the full onboarding record details.');
      return;
    }

    this.selectedRecord = selectedRecord;
    this.selectedSnapshot = this.parseJson<CustomerProfileSnapshot>(selectedRecord.snapshotJson);
    this.selectedAdditional = this.parseJson<AdditionalCustomerDetails>(selectedRecord.additionalDetailsJson);
    this.selectedAccountDetails = this.parseJson<AccountOpeningDetails>(selectedRecord.accountDetailsJson);
    this.selectedDocuments = this.parseJson<SupportingDocument[]>(selectedRecord.documentsJson)
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
    await this.loadNidPhotoPreview();
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

  statusClass(status: string): string {
    switch ((status || '').toUpperCase()) {
      case 'ACCOUNT_CREATED':
      case 'KYC_APPROVED':
        return 'bg-emerald-100 text-emerald-700';
      case 'KYC_REVIEWED':
        return 'bg-brand-100 text-brand-700';
      case 'PENDING_KYC_AUTHORIZATION':
      case 'KYC_PROCESSING':
        return 'bg-amber-100 text-amber-800';
      case 'REJECTED':
      case 'KYC_REJECTED':
      case 'DUPLICATE_CIF_BLOCKED':
        return 'bg-rose-100 text-rose-700';
      case 'FAILED':
      case 'FULFILLMENT_FAILED':
        return 'bg-amber-100 text-amber-700';
      default:
        return 'bg-slate-100 text-slate-700';
    }
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

  exportExcel(): void {
    this.exportBusy = true;
    this.workflow.getReport({ ...this.buildReportQuery(), page: 1, pageSize: -1 }).subscribe({
      next: (response) => {
        this.exportBusy = false;
        const rows = response.items || [];
        const headers = [
          'Case Reference',
          'Customer Name',
          'Customer Number',
          'Branch',
          'Account Class',
          'Opening Amount',
          'Funding Source',
          'Funding Value',
          'Account Number',
          'Status',
          'Maker',
          'Checker',
          'KYC Reviewer',
          'Submitted At',
          'Checker Reviewed At',
          'KYC Reviewed At'
        ];

        const csvRows = rows.map((record) => [
          record.caseReference || '',
          record.customerName || '',
          record.customerNumber || '',
          record.branchCode || '',
          record.accountClass || '',
          this.formatMoney(record.openingAmount),
          record.fundingSourceType || '',
          record.fundingSourceValue || '',
          record.accountNumber || '',
          record.status || '',
          record.makerUsername || '',
          record.checkerUsername || '',
          record.kycReviewerUsername || '',
          this.formatDateTime(record.submittedAtUtc),
          this.formatDateTime(record.reviewedAtUtc),
          this.formatDateTime(record.kycReviewedAtUtc)
        ]);

        const csvContent = [headers, ...csvRows]
          .map((row) => row.map((value) => `"${String(value ?? '').replace(/"/g, '""')}"`).join(','))
          .join('\r\n');

        this.downloadFile(csvContent, `${this.exportFilePrefix}-${this.buildFileDateStamp()}.csv`, 'text/csv;charset=utf-8;');
        this.toast.success('Excel export ready', 'The onboarding report was downloaded successfully.');
      },
      error: (error: any) => {
        this.exportBusy = false;
        this.toast.error('Export failed', error?.error?.message || error?.message || 'Unable to export the onboarding report.');
      }
    });
  }

  exportPdf(): void {
    this.exportBusy = true;
    this.workflow.getReport({ ...this.buildReportQuery(), page: 1, pageSize: -1 }).subscribe({
      next: (response) => {
        this.exportBusy = false;
        const records = response.items || [];
        const popup = window.open('', '_blank', 'width=1280,height=900');
        if (!popup) {
          this.toast.error('Popup blocked', 'Allow popups for this site to generate the PDF view.');
          return;
        }

        const dashboard = this.dashboardStats;
        const branchRows = this.filteredBranchStats
          .map((branch) => `
            <tr>
              <td>${branch.branchCode} - ${branch.branchName}</td>
              <td>${branch.today.pending}</td>
              <td>${branch.today.accountCreated}</td>
              <td>${branch.today.kycReviewed}</td>
              <td>${branch.today.failed}</td>
              <td>${branch.today.rejected}</td>
              <td>${this.formatMoney(branch.today.totalOpeningAmount)}</td>
              <td>${branch.grandTotal.pending}</td>
              <td>${branch.grandTotal.accountCreated}</td>
              <td>${branch.grandTotal.kycReviewed}</td>
              <td>${branch.grandTotal.failed}</td>
              <td>${branch.grandTotal.rejected}</td>
              <td>${this.formatMoney(branch.grandTotal.totalOpeningAmount)}</td>
            </tr>
          `)
          .join('');

        const recordRows = records
          .map((record) => `
            <tr>
              <td>${record.caseReference}</td>
              <td>${record.customerName}</td>
              <td>${record.customerNumber}</td>
              <td>${record.branchCode}</td>
              <td>${record.accountClass}</td>
              <td>${this.formatMoney(record.openingAmount)}</td>
              <td>${record.fundingSourceType}</td>
              <td>${record.accountNumber || '-'}</td>
              <td>${record.status}</td>
              <td>${record.makerUsername || '-'}</td>
              <td>${record.checkerUsername || '-'}</td>
              <td>${record.kycReviewerUsername || '-'}</td>
            </tr>
          `)
          .join('');

        popup.document.open();
        popup.document.write(`
          <!doctype html>
          <html>
            <head>
              <meta charset="utf-8" />
              <title>Onboarding Report</title>
              <style>
                body { font-family: Arial, sans-serif; color: #0f172a; padding: 24px; }
                h1, h2 { margin: 0 0 12px; }
                p { margin: 0 0 8px; color: #475569; }
                .summary { display: grid; grid-template-columns: repeat(5, minmax(0, 1fr)); gap: 12px; margin: 20px 0; }
                .card { border: 1px solid #dbe4ea; border-radius: 14px; padding: 14px; }
                .eyebrow { text-transform: uppercase; letter-spacing: 0.18em; font-size: 11px; color: #07522a; font-weight: 700; }
                .metric { font-size: 28px; font-weight: 700; color: #111827; margin-top: 8px; }
                table { width: 100%; border-collapse: collapse; margin-top: 12px; }
                th, td { border: 1px solid #dbe4ea; padding: 8px 10px; text-align: left; font-size: 12px; vertical-align: top; }
                th { background: #f8fafc; color: #475569; text-transform: uppercase; letter-spacing: 0.08em; }
              </style>
            </head>
            <body>
              <h1>Onboarding report</h1>
              <p>Date range: ${this.summaryRangeText}</p>
              <p>Generated: ${new Date().toLocaleString()}</p>
              ${dashboard ? `
                <div class="summary">
                  <div class="card"><div class="eyebrow">${this.summaryRangeLabel} pending</div><div class="metric">${dashboard.today.pending}</div><p>Grand total ${dashboard.grandTotal.pending}</p></div>
                  <div class="card"><div class="eyebrow">${this.summaryRangeLabel} account created</div><div class="metric">${dashboard.today.accountCreated}</div><p>Grand total ${dashboard.grandTotal.accountCreated}</p></div>
                  <div class="card"><div class="eyebrow">${this.summaryRangeLabel} KYC reviewed</div><div class="metric">${dashboard.today.kycReviewed}</div><p>Grand total ${dashboard.grandTotal.kycReviewed}</p></div>
                  <div class="card"><div class="eyebrow">${this.summaryRangeLabel} failed</div><div class="metric">${dashboard.today.failed}</div><p>Grand total ${dashboard.grandTotal.failed}</p></div>
                  <div class="card"><div class="eyebrow">${this.summaryRangeLabel} amount</div><div class="metric">${this.formatMoney(dashboard.today.totalOpeningAmount)}</div><p>Grand total ${this.formatMoney(dashboard.grandTotal.totalOpeningAmount)}</p></div>
                </div>
                <h2>Branch summary</h2>
                <table>
                  <thead>
                    <tr>
                      <th>Branch</th>
                      <th>${this.summaryRangeLabel} pending</th>
                      <th>${this.summaryRangeLabel} created</th>
                      <th>${this.summaryRangeLabel} KYC reviewed</th>
                      <th>${this.summaryRangeLabel} failed</th>
                      <th>${this.summaryRangeLabel} rejected</th>
                      <th>${this.summaryRangeLabel} amount</th>
                      <th>Grand pending</th>
                      <th>Grand created</th>
                      <th>Grand KYC reviewed</th>
                      <th>Grand failed</th>
                      <th>Grand rejected</th>
                      <th>Grand amount</th>
                    </tr>
                  </thead>
                  <tbody>${branchRows || '<tr><td colspan="13">No branch rows available.</td></tr>'}</tbody>
                </table>
              ` : ''}
              <h2>Records</h2>
              <table>
                <thead>
                  <tr>
                    <th>Case Ref</th>
                    <th>Customer</th>
                    <th>CIF</th>
                    <th>Branch</th>
                    <th>Class</th>
                    <th>Amount</th>
                    <th>Funding</th>
                    <th>Account</th>
                    <th>Status</th>
                    <th>Maker</th>
                    <th>Checker</th>
                    <th>KYC</th>
                  </tr>
                </thead>
                <tbody>${recordRows || '<tr><td colspan="12">No records found.</td></tr>'}</tbody>
              </table>
            </body>
          </html>
        `);
        popup.document.close();
        popup.focus();
        popup.print();
        this.toast.success('PDF view ready', 'The printable onboarding report view is ready.');
      },
      error: (error: any) => {
        this.exportBusy = false;
        this.toast.error('Export failed', error?.error?.message || error?.message || 'Unable to prepare the printable report.');
      }
    });
  }

  private buildReportQuery(): OnboardingReportQuery {
    return {
      search: this.searchTerm.trim(),
      status: this.statusFilter,
      fromDate: this.toStartOfDayIso(this.fromDate),
      toDate: this.toEndOfDayIso(this.toDate),
      page: this.currentPage,
      pageSize: this.pageSize,
      sortBy: 'submittedAtUtc',
      sortDirection: 'desc'
    };
  }

  private buildDashboardQuery(): Pick<OnboardingReportQuery, 'fromDate' | 'toDate'> {
    return {
      fromDate: this.toStartOfDayIso(this.fromDate),
      toDate: this.toEndOfDayIso(this.toDate)
    };
  }

  private syncBranchPagination(): void {
    if (this.branchPageSize !== -1) {
      this.branchCurrentPage = Math.min(this.branchCurrentPage, this.branchTotalPages);
    } else {
      this.branchCurrentPage = 1;
    }
  }

  private toStartOfDayIso(value: string): string | undefined {
    if (!value) {
      return undefined;
    }

    return new Date(`${value}T00:00:00`).toISOString();
  }

  private toEndOfDayIso(value: string): string | undefined {
    if (!value) {
      return undefined;
    }

    return new Date(`${value}T23:59:59.999`).toISOString();
  }

  private buildFileDateStamp(): string {
    const now = new Date();
    const yyyy = now.getFullYear();
    const mm = `${now.getMonth() + 1}`.padStart(2, '0');
    const dd = `${now.getDate()}`.padStart(2, '0');
    const hh = `${now.getHours()}`.padStart(2, '0');
    const min = `${now.getMinutes()}`.padStart(2, '0');
    return `${yyyy}${mm}${dd}-${hh}${min}`;
  }

  private formatMoney(value?: number | null): string {
    return Number(value || 0).toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 });
  }

  private formatDateTime(value?: string | null): string {
    return value ? new Date(value).toLocaleString() : '-';
  }

  private downloadFile(content: string, fileName: string, mimeType: string): void {
    const blob = new Blob([content], { type: mimeType });
    const url = window.URL.createObjectURL(blob);
    const anchor = document.createElement('a');
    anchor.href = url;
    anchor.download = fileName;
    anchor.click();
    window.URL.revokeObjectURL(url);
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
