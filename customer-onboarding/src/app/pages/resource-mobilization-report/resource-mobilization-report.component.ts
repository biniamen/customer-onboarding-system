import { Component, OnInit } from '@angular/core';
import {
  ResourceMobilizationDashboardPeriod,
  ResourceMobilizationDashboardStats,
  ResourceMobilizationRecord,
  ResourceMobilizationReportQuery,
  ResourceMobilizationReportResponse
} from 'src/app/models/onboarding.models';
import { AuthService } from 'src/app/services/auth.service';
import { ResourceMobilizationService } from 'src/app/services/resource-mobilization.service';
import { ToastService } from 'src/app/services/toast.service';

type ReportView = 'campaign' | 'transactions';

interface CampaignEmployeeRow {
  employeeReference: string;
  employeeFullName: string;
  monthlyTargetAmount: number;
  demandAmount: number;
  savingAmount: number;
  ifbAmount: number;
  totalDepositMobilized: number;
}

interface CampaignDepartmentGroup {
  name: string;
  employees: CampaignEmployeeRow[];
  totals: {
    demandAmount: number;
    savingAmount: number;
    ifbAmount: number;
    totalDepositMobilized: number;
  };
}

@Component({
  selector: 'app-resource-mobilization-report',
  templateUrl: './resource-mobilization-report.component.html',
  styleUrls: ['./resource-mobilization-report.component.css']
})
export class ResourceMobilizationReportComponent implements OnInit {
  readonly pageSizeOptions = [10, 20, 50, 100, -1];
  readonly statusOptions = ['', 'PENDING_CHECKER_APPROVAL', 'APPROVED', 'REJECTED'];
  readonly productTypeOptions = ['', 'DEMAND', 'SAVING', 'IFB'];
  readonly exportFilePrefix = 'resource-mobilization-report';

  loading = false;
  loadingDashboard = false;
  loadingCampaign = false;
  exportBusy = false;
  deleting = false;
  pageError: string | null = null;

  dashboardStats: ResourceMobilizationDashboardStats | null = null;
  selectedRecord: ResourceMobilizationRecord | null = null;

  searchTerm = '';
  statusFilter = '';
  productTypeFilter = '';
  fromDate = '';
  toDate = '';
  pageSize = 10;
  currentPage = 1;
  totalPages = 1;
  totalRecords = 0;
  records: ResourceMobilizationRecord[] = [];
  campaignGroups: CampaignDepartmentGroup[] = [];
  campaignEmployeeCount = 0;
  campaignGrandTotals = {
    demandAmount: 0,
    savingAmount: 0,
    ifbAmount: 0,
    totalDepositMobilized: 0
  };
  activeView: ReportView = 'campaign';

  readonly currentRole: string;

  constructor(
    private resourceMobilization: ResourceMobilizationService,
    private toast: ToastService,
    auth: AuthService
  ) {
    this.currentRole = auth.getCurrentUser()?.role || '';
  }

  ngOnInit(): void {
    this.refreshAll();
  }

  get isSystemAdmin(): boolean {
    return this.currentRole === 'SYSTEM_ADMIN';
  }

  get isSeniorManagement(): boolean {
    return this.currentRole === 'SENIOR_MANAGEMENT';
  }

  get isBranchBanking(): boolean {
    return this.currentRole === 'BRANCH_BANKING';
  }

  get reportScopeLabel(): string {
    if (this.dashboardStats?.scope === 'ALL_BRANCHES') {
      return 'System-wide scope';
    }

    return this.dashboardStats?.branchCode
      ? `Branch ${this.dashboardStats.branchCode} scope`
      : 'Branch scope';
  }

  get todayPeriod(): ResourceMobilizationDashboardPeriod | null {
    return this.dashboardStats?.today || null;
  }

  get weekPeriod(): ResourceMobilizationDashboardPeriod | null {
    return this.dashboardStats?.thisWeek || null;
  }

  get monthPeriod(): ResourceMobilizationDashboardPeriod | null {
    return this.dashboardStats?.thisMonth || null;
  }

  get campaignPeriodLabel(): string {
    if (this.fromDate && this.toDate) {
      return `From ${this.formatDateLabel(this.fromDate)} to ${this.formatDateLabel(this.toDate)}`;
    }

    if (this.fromDate) {
      return `From ${this.formatDateLabel(this.fromDate)}`;
    }

    if (this.toDate) {
      return `Up to ${this.formatDateLabel(this.toDate)}`;
    }

    return 'All approved registrations';
  }

  compactAmount(value?: number | null): string {
    return Number(value || 0).toLocaleString(undefined, {
      minimumFractionDigits: 2,
      maximumFractionDigits: 2
    });
  }

  refreshAll(): void {
    this.loadDashboard();
    this.loadReport();
    this.loadCampaignRegister();
  }

  loadReport(): void {
    this.loading = true;
    this.pageError = null;

    this.resourceMobilization.getReport(this.buildReportQuery()).subscribe({
      next: (response: ResourceMobilizationReportResponse) => {
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
        this.pageError = error?.error?.message || error?.message || 'Unable to load the resource mobilization report.';
        this.toast.error('Report failed', this.pageError || 'Unable to load the report.');
      }
    });
  }

  loadDashboard(): void {
    this.loadingDashboard = true;

    this.resourceMobilization.getDashboardStats().subscribe({
      next: (stats) => {
        this.loadingDashboard = false;
        this.dashboardStats = stats;
      },
      error: (error: any) => {
        this.loadingDashboard = false;
        this.dashboardStats = null;
        if (error?.error?.message) {
          this.toast.error('Dashboard failed', error.error.message);
        }
      }
    });
  }

  loadCampaignRegister(): void {
    this.loadingCampaign = true;
    const campaignQuery: ResourceMobilizationReportQuery = {
      ...this.buildReportQuery(),
      status: 'APPROVED',
      page: 1,
      pageSize: -1,
      sortBy: 'employeeFullName',
      sortDirection: 'asc'
    };

    this.resourceMobilization.getReport(campaignQuery).subscribe({
      next: (response) => {
        this.loadingCampaign = false;
        this.buildCampaignRegister(response.items || []);
      },
      error: (error: any) => {
        this.loadingCampaign = false;
        this.campaignGroups = [];
        this.campaignEmployeeCount = 0;
        this.campaignGrandTotals = this.emptyCampaignTotals();
        this.toast.error('Campaign report failed', error?.error?.message || error?.message || 'Unable to load the campaign summary.');
      }
    });
  }

  applyFilters(): void {
    this.currentPage = 1;
    this.loadReport();
    this.loadCampaignRegister();
  }

  clearFilters(): void {
    this.searchTerm = '';
    this.statusFilter = '';
    this.productTypeFilter = '';
    this.fromDate = '';
    this.toDate = '';
    this.pageSize = 10;
    this.currentPage = 1;
    this.loadReport();
    this.loadCampaignRegister();
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

  selectRecord(record: ResourceMobilizationRecord): void {
    this.selectedRecord = record;
  }

  closeDetailsModal(): void {
    this.selectedRecord = null;
  }

  deleteSelected(): void {
    if (!this.selectedRecord || !this.isSystemAdmin) {
      return;
    }

    if (!window.confirm(`Delete resource mobilization record ${this.selectedRecord.registrationReference}?`)) {
      return;
    }

    this.deleting = true;
    const deletingId = this.selectedRecord.id;
    this.resourceMobilization.remove(deletingId).subscribe({
      next: () => {
        this.deleting = false;
        this.toast.success('Deleted', 'Selected request deleted.');
        this.closeDetailsModal();
        this.records = this.records.filter((item) => item.id !== deletingId);
        this.totalRecords = Math.max(0, this.totalRecords - 1);
        this.refreshAll();
      },
      error: (error: any) => {
        this.deleting = false;
        this.toast.error('Delete failed', error?.error?.message || error?.message || 'Unable to delete the selected request.');
      }
    });
  }

  statusClass(status: string): string {
    switch ((status || '').toUpperCase()) {
      case 'APPROVED':
        return 'bg-emerald-100 text-emerald-700';
      case 'REJECTED':
        return 'bg-rose-100 text-rose-700';
      default:
        return 'bg-brand-100 text-brand-700';
    }
  }

  productMarker(record: ResourceMobilizationRecord, productType: string): string {
    return record.depositProductType.toUpperCase() === productType ? 'Yes' : '-';
  }

  exportPdf(): void {
    this.exportBusy = true;
    this.resourceMobilization.getReport({
      ...this.buildReportQuery(),
      status: 'APPROVED',
      page: 1,
      pageSize: -1,
      sortBy: 'employeeFullName',
      sortDirection: 'asc'
    }).subscribe({
      next: (response) => {
        this.exportBusy = false;
        const records = response.items || [];
        this.buildCampaignRegister(records);
        const popup = window.open('', '_blank', 'width=1400,height=900');
        if (!popup) {
          this.toast.error('Popup blocked', 'Allow popups to export PDF.');
          return;
        }

        const groups = this.campaignGroups.map((group) => {
          const rows = group.employees.map((employee, index) => `
            <tr>
              <td>${index + 1}</td>
              <td>${this.escapeHtml(group.name)}</td>
              <td>${this.escapeHtml(employee.employeeFullName)}</td>
              <td class="number">${this.formatMoney(employee.monthlyTargetAmount)}</td>
              <td class="number">${employee.demandAmount ? this.formatMoney(employee.demandAmount) : ''}</td>
              <td class="number">${employee.savingAmount ? this.formatMoney(employee.savingAmount) : ''}</td>
              <td class="number">${employee.ifbAmount ? this.formatMoney(employee.ifbAmount) : ''}</td>
              <td class="number total">${this.formatMoney(employee.totalDepositMobilized)}</td>
            </tr>
          `).join('');
          return `${rows}
            <tr class="subtotal">
              <td colspan="2">${this.escapeHtml(group.name)} Total</td>
              <td class="number">${group.employees.length} employee${group.employees.length === 1 ? '' : 's'}</td>
              <td></td>
              <td class="number">${group.totals.demandAmount ? this.formatMoney(group.totals.demandAmount) : ''}</td>
              <td class="number">${group.totals.savingAmount ? this.formatMoney(group.totals.savingAmount) : ''}</td>
              <td class="number">${group.totals.ifbAmount ? this.formatMoney(group.totals.ifbAmount) : ''}</td>
              <td class="number total">${this.formatMoney(group.totals.totalDepositMobilized)}</td>
            </tr>`;
        }).join('');

        popup.document.open();
        popup.document.write(`
          <!doctype html>
          <html>
            <head>
              <meta charset="utf-8" />
              <title>Resource Mobilization Campaign Report</title>
              <style>
                @page { size: landscape; margin: 12mm; }
                body { color: #172033; font-family: Georgia, 'Times New Roman', serif; }
                .heading { border-bottom: 4px solid #eab308; color: #064e2b; padding-bottom: 12px; text-align: center; }
                .heading p, .heading h1, .heading h2, .heading span { margin: 0; }
                .heading p { font-family: Arial, sans-serif; font-size: 12px; font-weight: 800; letter-spacing: 1.6px; }
                .heading h1 { font-size: 23px; margin-top: 4px; }
                .heading h2 { font-size: 16px; margin-top: 5px; }
                .heading span { color: #475569; display: inline-block; font-family: Arial, sans-serif; font-size: 10px; font-weight: 700; margin-top: 8px; }
                table { border-collapse: collapse; margin-top: 18px; width: 100%; }
                th, td { border: 1px solid #64748b; font-size: 10px; padding: 5px 6px; vertical-align: middle; }
                th { background: #edf4ee; color: #064e2b; font-family: Arial, sans-serif; text-align: center; }
                .number { text-align: right; white-space: nowrap; }
                .total { font-weight: 800; }
                .subtotal { background: #e8f1e9; color: #064e2b; font-weight: 800; }
                tfoot { background: #14532d; color: #fff; font-family: Arial, sans-serif; font-weight: 800; }
              </style>
            </head>
            <body>
              <div class="heading">
                <p>GLOBAL BANK ETHIOPIA</p>
                <h1>Resource Mobilization Campaign Report</h1>
                <h2>${this.escapeHtml(this.campaignPeriodLabel)}</h2>
                <span>${this.escapeHtml(this.reportScopeLabel)} | Approved deposit registrations</span>
              </div>
              <table>
                <thead>
                  <tr>
                    <th rowspan="2">Sr.No</th>
                    <th rowspan="2">Department</th>
                    <th rowspan="2">Staff Name</th>
                    <th rowspan="2">Monthly Target / Budget</th>
                    <th colspan="3">Deposit Product Type</th>
                    <th rowspan="2">Total Deposit Mobilized</th>
                  </tr>
                  <tr>
                    <th>Demand</th>
                    <th>Saving</th>
                    <th>IFB</th>
                  </tr>
                </thead>
                <tbody>${groups || '<tr><td colspan="8">No approved campaign registrations match the selected filters.</td></tr>'}</tbody>
                <tfoot>
                  <tr>
                    <td colspan="3">Grand Total</td>
                    <td class="number">${this.campaignEmployeeCount} employee${this.campaignEmployeeCount === 1 ? '' : 's'}</td>
                    <td class="number">${this.formatMoney(this.campaignGrandTotals.demandAmount)}</td>
                    <td class="number">${this.formatMoney(this.campaignGrandTotals.savingAmount)}</td>
                    <td class="number">${this.formatMoney(this.campaignGrandTotals.ifbAmount)}</td>
                    <td class="number">${this.formatMoney(this.campaignGrandTotals.totalDepositMobilized)}</td>
                  </tr>
                </tfoot>
              </table>
            </body>
          </html>
        `);
        popup.document.close();
        popup.focus();
        popup.print();
        this.toast.success('PDF ready', 'Use the print dialog to save the PDF.');
      },
      error: (error: any) => {
        this.exportBusy = false;
        this.toast.error('Export failed', error?.error?.message || error?.message || 'Unable to prepare the PDF.');
      }
    });
  }

  private buildReportQuery(): ResourceMobilizationReportQuery {
    return {
      search: this.searchTerm.trim(),
      status: this.statusFilter,
      depositProductType: this.productTypeFilter,
      fromDate: this.toStartOfDayIso(this.fromDate),
      toDate: this.toEndOfDayIso(this.toDate),
      page: this.currentPage,
      pageSize: this.pageSize,
      sortBy: 'transactionValueDate',
      sortDirection: 'desc'
    };
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

  private formatMoney(value?: number | null): string {
    return Number(value || 0).toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 });
  }

  private buildCampaignRegister(records: ResourceMobilizationRecord[]): void {
    const departmentLookup = new Map<string, Map<string, CampaignEmployeeRow>>();

    records.forEach((record) => {
      const department = this.resolveCampaignDepartment(record);
      const employeeKey = `${record.employeeReference}|${record.employeeFullName}`;
      let employees = departmentLookup.get(department);
      if (!employees) {
        employees = new Map<string, CampaignEmployeeRow>();
        departmentLookup.set(department, employees);
      }

      let employee = employees.get(employeeKey);
      if (!employee) {
        employee = {
          employeeReference: record.employeeReference,
          employeeFullName: record.employeeFullName,
          monthlyTargetAmount: Number(record.monthlyTargetAmount || 0),
          demandAmount: 0,
          savingAmount: 0,
          ifbAmount: 0,
          totalDepositMobilized: 0
        };
        employees.set(employeeKey, employee);
      }

      employee.monthlyTargetAmount = Math.max(employee.monthlyTargetAmount, Number(record.monthlyTargetAmount || 0));
      const amount = Number(record.totalDepositMobilized || 0);
      switch ((record.depositProductType || '').toUpperCase()) {
        case 'DEMAND':
          employee.demandAmount += amount;
          break;
        case 'IFB':
          employee.ifbAmount += amount;
          break;
        default:
          employee.savingAmount += amount;
          break;
      }
      employee.totalDepositMobilized += amount;
    });

    this.campaignGroups = Array.from(departmentLookup.entries())
      .map(([name, employees]) => {
        const employeeRows = Array.from(employees.values())
          .sort((left, right) => left.employeeFullName.localeCompare(right.employeeFullName));
        return {
          name,
          employees: employeeRows,
          totals: employeeRows.reduce((total, employee) => ({
            demandAmount: total.demandAmount + employee.demandAmount,
            savingAmount: total.savingAmount + employee.savingAmount,
            ifbAmount: total.ifbAmount + employee.ifbAmount,
            totalDepositMobilized: total.totalDepositMobilized + employee.totalDepositMobilized
          }), this.emptyCampaignTotals())
        };
      })
      .sort((left, right) => left.name.localeCompare(right.name));

    this.campaignEmployeeCount = this.campaignGroups.reduce((total, group) => total + group.employees.length, 0);
    this.campaignGrandTotals = this.campaignGroups.reduce((total, group) => ({
      demandAmount: total.demandAmount + group.totals.demandAmount,
      savingAmount: total.savingAmount + group.totals.savingAmount,
      ifbAmount: total.ifbAmount + group.totals.ifbAmount,
      totalDepositMobilized: total.totalDepositMobilized + group.totals.totalDepositMobilized
    }), this.emptyCampaignTotals());
  }

  private resolveCampaignDepartment(record: ResourceMobilizationRecord): string {
    return record.employeeDepartmentName?.trim()
      || (record.employeeBranchCode ? `${record.employeeBranchCode}${record.employeeBranchName ? ' - ' + record.employeeBranchName : ''}` : '')
      || 'Unassigned department';
  }

  private emptyCampaignTotals(): CampaignDepartmentGroup['totals'] {
    return {
      demandAmount: 0,
      savingAmount: 0,
      ifbAmount: 0,
      totalDepositMobilized: 0
    };
  }

  private formatDateLabel(value: string): string {
    return new Date(`${value}T00:00:00`).toLocaleDateString(undefined, {
      year: 'numeric',
      month: 'long',
      day: 'numeric'
    });
  }

  private escapeHtml(value: string): string {
    return String(value || '').replace(/[&<>'"]/g, (character) => ({
      '&': '&amp;',
      '<': '&lt;',
      '>': '&gt;',
      "'": '&#39;',
      '"': '&quot;'
    }[character] || character));
  }
}
