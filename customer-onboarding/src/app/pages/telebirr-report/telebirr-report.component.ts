import { Component, OnInit } from '@angular/core';
import {
  TelebirrBranchStats,
  TelebirrDashboardStats,
  TelebirrTransferRecord,
  TelebirrTransferReportQuery,
  TelebirrTransferReportResponse
} from 'src/app/models/onboarding.models';
import { ReceiptPrintService } from 'src/app/services/receipt-print.service';
import { TelebirrTransferService } from 'src/app/services/telebirr-transfer.service';
import { ToastService } from 'src/app/services/toast.service';

@Component({
  selector: 'app-telebirr-report',
  templateUrl: './telebirr-report.component.html',
  styleUrls: ['./telebirr-report.component.css']
})
export class TelebirrReportComponent implements OnInit {
  readonly pageSizeOptions = [10, 20, 50, 100, -1];
  readonly statusOptions = ['', 'PENDING', 'APPROVED', 'FAILED', 'REJECTED'];
  readonly exportFilePrefix = 'telebirr-transfer-report';

  loading = false;
  loadingDashboard = false;
  exportBusy = false;
  pageError: string | null = null;
  selectedRecord: TelebirrTransferRecord | null = null;
  dashboardStats: TelebirrDashboardStats | null = null;

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

  records: TelebirrTransferRecord[] = [];

  constructor(
    private telebirrTransfers: TelebirrTransferService,
    private toast: ToastService,
    private receiptPrinter: ReceiptPrintService
  ) {}

  ngOnInit(): void {
    this.refreshAll();
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

  get branchStats(): TelebirrBranchStats[] {
    return this.dashboardStats?.branches || [];
  }

  get filteredBranchStats(): TelebirrBranchStats[] {
    const keyword = this.branchSearchTerm.trim().toLowerCase();
    if (!keyword) {
      return this.branchStats;
    }

    return this.branchStats.filter((branch) => {
      const combined = `${branch.branchCode} ${branch.branchName}`.toLowerCase();
      return combined.includes(keyword);
    });
  }

  get branchTotalPages(): number {
    if (this.branchPageSize === -1) {
      return 1;
    }

    return Math.max(1, Math.ceil(this.filteredBranchStats.length / this.branchPageSize));
  }

  get pagedBranchStats(): TelebirrBranchStats[] {
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

    this.telebirrTransfers.getReport(this.buildReportQuery()).subscribe({
      next: (response: TelebirrTransferReportResponse) => {
        this.loading = false;
        this.records = response.items || [];
        this.totalPages = response.totalPages || 1;
        this.totalRecords = response.totalRecords || 0;
        this.currentPage = response.page || 1;
        if (this.selectedRecord && !this.records.some((item) => item.id === this.selectedRecord?.id)) {
          this.selectedRecord = null;
        }
      },
      error: (error: any) => {
        this.loading = false;
        this.pageError = error?.error?.message || error?.message || 'Unable to load Telebirr report data.';
        this.toast.error('Report load failed', this.pageError || 'Report load failed.');
      }
    });
  }

  loadDashboard(): void {
    this.loadingDashboard = true;

    this.telebirrTransfers.getDashboardStats(this.buildDashboardQuery()).subscribe({
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

  selectRecord(record: TelebirrTransferRecord): void {
    this.selectedRecord = record;
  }

  closeDetailsModal(): void {
    this.selectedRecord = null;
  }

  statusClass(status: string): string {
    switch ((status || '').toUpperCase()) {
      case 'APPROVED':
        return 'bg-emerald-100 text-emerald-700';
      case 'REJECTED':
        return 'bg-rose-100 text-rose-700';
      case 'FAILED':
        return 'bg-amber-100 text-amber-700';
      default:
        return 'bg-brand-100 text-brand-700';
    }
  }

  printReceipt(record: TelebirrTransferRecord): void {
    if (!this.canPrintReceipt(record)) {
      this.toast.error('Receipt unavailable', 'Receipt can be printed only for approved or completed transactions.');
      return;
    }

    this.receiptPrinter.printTelebirrReceipt(record);
  }

  canPrintReceipt(record: TelebirrTransferRecord): boolean {
    return this.receiptPrinter.canPrintForStatus(record.status);
  }

  exportExcel(): void {
    this.exportBusy = true;
    this.telebirrTransfers.getReport({ ...this.buildReportQuery(), page: 1, pageSize: -1 }).subscribe({
      next: (response) => {
        this.exportBusy = false;
        const rows = response.items || [];
        const headers = [
          'Customer Name',
          'Account Number',
          'Branch',
          'Agent Code',
          'Agent Name',
          'Amount',
          'Currency',
          'Status',
          'CBS Reference',
          'Telebirr Reference',
          'Maker',
          'Checker',
          'Created At',
          'Approved At',
          'Narration',
          'Result'
        ];

        const csvRows = rows.map((record) => [
          record.customerName || '',
          record.accountNumber || '',
          record.accountBranchCode || '',
          record.telebirrShortCode || '',
          record.telebirrOrganizationName || '',
          this.formatMoney(record.amount),
          record.currency || '',
          record.status || '',
          record.cbsReference || '',
          record.transactionId || '',
          record.makerUserName || '',
          record.checkerUserName || '',
          this.formatDateTime(record.createdAt),
          this.formatDateTime(record.approvedAt),
          record.narration || '',
          record.resultDesc || record.responseDesc || ''
        ]);

        const csvContent = [headers, ...csvRows]
          .map((row) => row.map((value) => `"${String(value ?? '').replace(/"/g, '""')}"`).join(','))
          .join('\r\n');

        this.downloadFile(csvContent, `${this.exportFilePrefix}-${this.buildFileDateStamp()}.csv`, 'text/csv;charset=utf-8;');
        this.toast.success('Excel export ready', 'The current transfer report was downloaded successfully.');
      },
      error: (error: any) => {
        this.exportBusy = false;
        this.toast.error('Export failed', error?.error?.message || error?.message || 'Unable to export the transfer report.');
      }
    });
  }

  exportPdf(): void {
    this.exportBusy = true;
    this.telebirrTransfers.getReport({ ...this.buildReportQuery(), page: 1, pageSize: -1 }).subscribe({
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
              <td>${branch.today.approved}</td>
              <td>${branch.today.failed}</td>
              <td>${branch.today.rejected}</td>
              <td>${this.formatMoney(branch.today.totalTransferredAmount)}</td>
              <td>${branch.today.distinctAgents}</td>
              <td>${branch.grandTotal.approved}</td>
              <td>${branch.grandTotal.failed}</td>
              <td>${branch.grandTotal.rejected}</td>
              <td>${this.formatMoney(branch.grandTotal.totalTransferredAmount)}</td>
              <td>${branch.grandTotal.distinctAgents}</td>
            </tr>
          `)
          .join('');

        const recordRows = records
          .map((record) => `
            <tr>
              <td>${record.customerName || '-'}</td>
              <td>${record.accountNumber}</td>
              <td>${record.accountBranchCode || '-'}</td>
              <td>${record.telebirrShortCode || '-'}</td>
              <td>${this.formatMoney(record.amount)} ${record.currency}</td>
              <td>${record.status}</td>
              <td>${record.cbsReference || '-'}</td>
              <td>${record.transactionId || '-'}</td>
              <td>${record.makerUserName || '-'}</td>
              <td>${record.checkerUserName || '-'}</td>
              <td>${this.formatDateTime(record.createdAt)}</td>
            </tr>
          `)
          .join('');

        popup.document.open();
        popup.document.write(`
          <!doctype html>
          <html>
            <head>
              <meta charset="utf-8" />
              <title>Telebirr Transfer Report</title>
              <style>
                body { font-family: Arial, sans-serif; color: #0f172a; padding: 24px; }
                h1, h2 { margin: 0 0 12px; }
                p { margin: 0 0 8px; color: #475569; }
                .summary { display: grid; grid-template-columns: repeat(4, minmax(0, 1fr)); gap: 12px; margin: 20px 0; }
                .card { border: 1px solid #dbe4ea; border-radius: 14px; padding: 14px; }
                .eyebrow { text-transform: uppercase; letter-spacing: 0.18em; font-size: 11px; color: #07522a; font-weight: 700; }
                .metric { font-size: 28px; font-weight: 700; color: #111827; margin-top: 8px; }
                table { width: 100%; border-collapse: collapse; margin-top: 12px; }
                th, td { border: 1px solid #dbe4ea; padding: 8px 10px; text-align: left; font-size: 12px; vertical-align: top; }
                th { background: #f8fafc; color: #475569; text-transform: uppercase; letter-spacing: 0.08em; }
              </style>
            </head>
            <body>
              <h1>Telebirr transfer report</h1>
              <p>Date range: ${this.summaryRangeText}</p>
              <p>Generated: ${new Date().toLocaleString()}</p>
              ${dashboard ? `
                <div class="summary">
                  <div class="card"><div class="eyebrow">${this.summaryRangeLabel} approved</div><div class="metric">${dashboard.today.approved}</div><p>Grand total ${dashboard.grandTotal.approved}</p></div>
                  <div class="card"><div class="eyebrow">${this.summaryRangeLabel} failed</div><div class="metric">${dashboard.today.failed}</div><p>Grand total ${dashboard.grandTotal.failed}</p></div>
                  <div class="card"><div class="eyebrow">${this.summaryRangeLabel} agents</div><div class="metric">${dashboard.today.distinctAgents}</div><p>Grand total ${dashboard.grandTotal.distinctAgents}</p></div>
                  <div class="card"><div class="eyebrow">${this.summaryRangeLabel} amount</div><div class="metric">${this.formatMoney(dashboard.today.totalTransferredAmount)}</div><p>Grand total ${this.formatMoney(dashboard.grandTotal.totalTransferredAmount)}</p></div>
                </div>
                <h2>Branch summary</h2>
                <table>
                  <thead>
                    <tr>
                      <th>Branch</th>
                      <th>${this.summaryRangeLabel} approved</th>
                      <th>${this.summaryRangeLabel} failed</th>
                      <th>${this.summaryRangeLabel} rejected</th>
                      <th>${this.summaryRangeLabel} amount</th>
                      <th>${this.summaryRangeLabel} agents</th>
                      <th>Grand approved</th>
                      <th>Grand failed</th>
                      <th>Grand rejected</th>
                      <th>Grand amount</th>
                      <th>Grand agents</th>
                    </tr>
                  </thead>
                  <tbody>${branchRows || '<tr><td colspan="11">No branch rows available.</td></tr>'}</tbody>
                </table>
              ` : ''}
              <h2>Transactions</h2>
              <table>
                <thead>
                  <tr>
                    <th>Customer</th>
                    <th>Account</th>
                    <th>Branch</th>
                    <th>Agent</th>
                    <th>Amount</th>
                    <th>Status</th>
                    <th>CBS Ref</th>
                    <th>Telebirr Ref</th>
                    <th>Maker</th>
                    <th>Checker</th>
                    <th>Created</th>
                  </tr>
                </thead>
                <tbody>${recordRows || '<tr><td colspan="11">No transactions found.</td></tr>'}</tbody>
              </table>
            </body>
          </html>
        `);
        popup.document.close();
        popup.focus();
        popup.print();
        this.toast.success('PDF view ready', 'The printable report view is ready. Save it as PDF from the print dialog.');
      },
      error: (error: any) => {
        this.exportBusy = false;
        this.toast.error('Export failed', error?.error?.message || error?.message || 'Unable to prepare the printable report.');
      }
    });
  }

  private buildReportQuery(): TelebirrTransferReportQuery {
    return {
      search: this.searchTerm.trim(),
      status: this.statusFilter,
      fromDate: this.toStartOfDayIso(this.fromDate),
      toDate: this.toEndOfDayIso(this.toDate),
      page: this.currentPage,
      pageSize: this.pageSize,
      sortBy: 'createdAt',
      sortDirection: 'desc'
    };
  }

  private buildDashboardQuery(): Pick<TelebirrTransferReportQuery, 'fromDate' | 'toDate'> {
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
}
