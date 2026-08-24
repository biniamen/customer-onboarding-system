import { Component, OnInit } from '@angular/core';
import {
  PasswordMessageAuditLogItem,
  PasswordMessageAuditLogResponse
} from 'src/app/models/onboarding.models';
import { PasswordManagementService } from 'src/app/services/password-management.service';
import { ToastService } from 'src/app/services/toast.service';

@Component({
  selector: 'app-password-message-audit-log',
  templateUrl: './password-message-audit-log.component.html',
  styleUrls: ['./password-message-audit-log.component.css']
})
export class PasswordMessageAuditLogComponent implements OnInit {
  readonly pageSizeOptions = [10, 20, 50, 100, -1];

  loading = false;
  pageError: string | null = null;

  records: PasswordMessageAuditLogItem[] = [];
  searchTerm = '';
  fromDate = '';
  toDate = '';
  pageSize = 20;
  currentPage = 1;
  totalPages = 1;
  totalRecords = 0;

  get sentCount(): number {
    return this.records.filter((item) => item.sent === true).length;
  }

  get failedCount(): number {
    return this.records.filter((item) => item.sent === false).length;
  }

  get newUserCount(): number {
    return this.records.filter((item) => item.action === 'SEND_NEW_USER_CREDENTIAL_SMS').length;
  }

  constructor(
    private passwordManagement: PasswordManagementService,
    private toast: ToastService
  ) {}

  ngOnInit(): void {
    this.loadLogs();
  }

  loadLogs(): void {
    this.loading = true;
    this.pageError = null;

    this.passwordManagement.getPasswordMessageAuditLogs({
      search: this.searchTerm.trim(),
      fromDate: this.fromDate ? new Date(`${this.fromDate}T00:00:00`).toISOString() : undefined,
      toDate: this.toDate ? new Date(`${this.toDate}T23:59:59.999`).toISOString() : undefined,
      page: this.currentPage,
      pageSize: this.pageSize
    }).subscribe({
      next: (response: PasswordMessageAuditLogResponse) => {
        this.loading = false;
        this.records = response.items || [];
        this.totalRecords = response.totalRecords || 0;
        this.totalPages = response.totalPages || 1;
        this.currentPage = response.page || 1;
      },
      error: (error: any) => {
        this.loading = false;
        this.pageError = error?.error?.message || error?.message || 'Unable to load SMS audit logs.';
        this.toast.error('Load failed', this.pageError || 'Load failed.');
      }
    });
  }

  applyFilters(): void {
    this.currentPage = 1;
    this.loadLogs();
  }

  clearFilters(): void {
    this.searchTerm = '';
    this.fromDate = '';
    this.toDate = '';
    this.pageSize = 20;
    this.currentPage = 1;
    this.loadLogs();
  }

  updatePageSize(value: string | number): void {
    const parsed = Number(value);
    this.pageSize = Number.isFinite(parsed) ? parsed : 20;
    this.currentPage = 1;
    this.loadLogs();
  }

  changePage(page: number): void {
    if (page < 1 || page > this.totalPages || page === this.currentPage) {
      return;
    }

    this.currentPage = page;
    this.loadLogs();
  }

  actionLabel(action: string): string {
    return action === 'SEND_NEW_USER_CREDENTIAL_SMS'
      ? 'New user SMS'
      : 'Password reset SMS';
  }

  statusLabel(record: PasswordMessageAuditLogItem): string {
    if (record.sent === true) {
      return 'Sent';
    }

    if (record.sent === false) {
      return 'Failed';
    }

    return 'Unknown';
  }
}
