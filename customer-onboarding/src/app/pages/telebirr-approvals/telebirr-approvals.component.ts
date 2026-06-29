import { Component, OnInit } from '@angular/core';
import { TelebirrTransferRecord } from 'src/app/models/onboarding.models';
import { ReceiptPrintService } from 'src/app/services/receipt-print.service';
import { TelebirrTransferService } from 'src/app/services/telebirr-transfer.service';
import { ToastService } from 'src/app/services/toast.service';

@Component({
  selector: 'app-telebirr-approvals',
  templateUrl: './telebirr-approvals.component.html',
  styleUrls: ['./telebirr-approvals.component.css']
})
export class TelebirrApprovalsComponent implements OnInit {
  readonly pageSizeOptions = [10, 20, 50, 100, -1];
  loading = false;
  loadingCompleted = false;
  acting = false;
  pageError: string | null = null;
  searchTerm = '';
  checkerComment = '';
  rejectionReason = '';
  pageIndex = 0;
  pageSize = 10;

  requests: TelebirrTransferRecord[] = [];
  completedRequests: TelebirrTransferRecord[] = [];
  selectedRequest: TelebirrTransferRecord | null = null;
  selectedCompleted: TelebirrTransferRecord | null = null;
  completedSearchTerm = '';
  completedPageIndex = 0;
  completedPageSize = 10;

  constructor(
    private telebirrTransfers: TelebirrTransferService,
    private toast: ToastService,
    private receiptPrinter: ReceiptPrintService
  ) {}

  ngOnInit(): void {
    this.loadRequests();
    this.loadCompletedRequests();
  }

  get filteredRequests(): TelebirrTransferRecord[] {
    const term = this.searchTerm.trim().toLowerCase();
    if (!term) {
      return this.requests;
    }

    return this.requests.filter((record) =>
      [
        record.accountNumber,
        record.customerName,
        record.telebirrShortCode,
        record.telebirrOrganizationName,
        record.makerUserName,
        record.status
      ]
        .filter(Boolean)
        .some((value) => `${value}`.toLowerCase().includes(term))
    );
  }

  get pagedRequests(): TelebirrTransferRecord[] {
    if (this.pageSize === -1) {
      return this.filteredRequests;
    }

    const start = this.pageIndex * this.pageSize;
    return this.filteredRequests.slice(start, start + this.pageSize);
  }

  get totalPages(): number {
    if (this.pageSize === -1) {
      return 1;
    }

    return Math.max(1, Math.ceil(this.filteredRequests.length / this.pageSize));
  }

  get filteredCompletedRequests(): TelebirrTransferRecord[] {
    const term = this.completedSearchTerm.trim().toLowerCase();
    if (!term) {
      return this.completedRequests;
    }

    return this.completedRequests.filter((record) =>
      [
        record.accountNumber,
        record.customerName,
        record.telebirrShortCode,
        record.telebirrOrganizationName,
        record.cbsReference,
        record.transactionId,
        record.status,
        record.makerUserName,
        record.checkerUserName
      ]
        .filter(Boolean)
        .some((value) => `${value}`.toLowerCase().includes(term))
    );
  }

  get pagedCompletedRequests(): TelebirrTransferRecord[] {
    if (this.completedPageSize === -1) {
      return this.filteredCompletedRequests;
    }

    const start = this.completedPageIndex * this.completedPageSize;
    return this.filteredCompletedRequests.slice(start, start + this.completedPageSize);
  }

  get totalCompletedPages(): number {
    if (this.completedPageSize === -1) {
      return 1;
    }

    return Math.max(1, Math.ceil(this.filteredCompletedRequests.length / this.completedPageSize));
  }

  loadRequests(): void {
    this.loading = true;
    this.pageError = null;

    this.telebirrTransfers.getPending().subscribe({
      next: (records) => {
        this.loading = false;
        this.requests = records;
        if (!this.selectedRequest && records.length) {
          this.selectedRequest = records[0];
        } else if (this.selectedRequest) {
          this.selectedRequest = records.find((item) => item.id === this.selectedRequest?.id) || records[0] || null;
        }
        this.pageIndex = 0;
      },
      error: (error: any) => {
        this.loading = false;
        this.pageError = error?.error?.message || error?.message || 'Unable to load pending transfer requests.';
        this.toast.error('Queue unavailable', this.pageError || 'Queue unavailable.');
      }
    });
  }

  loadCompletedRequests(): void {
    this.loadingCompleted = true;

    this.telebirrTransfers.getCompleted().subscribe({
      next: (records) => {
        this.loadingCompleted = false;
        this.completedRequests = [...records]
          .sort((a, b) => new Date(b.approvedAt || b.rejectedAt || b.createdAt).getTime() - new Date(a.approvedAt || a.rejectedAt || a.createdAt).getTime());
        this.completedPageIndex = 0;
        if (this.selectedCompleted && !this.completedRequests.some((item) => item.id === this.selectedCompleted?.id)) {
          this.selectedCompleted = null;
        }
      },
      error: () => {
        this.loadingCompleted = false;
        this.completedRequests = [];
      }
    });
  }

  selectRequest(record: TelebirrTransferRecord): void {
    this.selectedRequest = record;
    this.checkerComment = '';
    this.rejectionReason = '';
  }

  approveSelected(): void {
    if (!this.selectedRequest) {
      return;
    }

    this.acting = true;
    this.telebirrTransfers.approve(this.selectedRequest.id, this.checkerComment.trim()).subscribe({
      next: (record) => {
        this.acting = false;
        this.toast.success('Transfer approved', record.responseDesc || 'The transfer request was approved successfully.');
        this.removeHandledRecord(record.id);
        this.loadCompletedRequests();
      },
      error: (error: any) => {
        this.acting = false;
        const message = error?.error?.message || error?.message || 'Unable to approve the transfer request.';
        this.toast.error('Approval failed', message);
      }
    });
  }

  rejectSelected(): void {
    if (!this.selectedRequest) {
      return;
    }

    const reason = this.rejectionReason.trim();
    if (!reason) {
      this.toast.error('Reason required', 'Please enter a short reason before rejecting the request.');
      return;
    }

    this.acting = true;
    this.telebirrTransfers.reject(this.selectedRequest.id, reason).subscribe({
      next: () => {
        this.acting = false;
        this.toast.success('Transfer rejected', 'The transfer request was rejected successfully.');
        this.removeHandledRecord(this.selectedRequest!.id);
        this.loadCompletedRequests();
      },
      error: (error: any) => {
        this.acting = false;
        const message = error?.error?.message || error?.message || 'Unable to reject the transfer request.';
        this.toast.error('Rejection failed', message);
      }
    });
  }

  previousPage(): void {
    if (this.pageIndex > 0) {
      this.pageIndex -= 1;
    }
  }

  nextPage(): void {
    if (this.pageIndex < this.totalPages - 1) {
      this.pageIndex += 1;
    }
  }

  updatePendingSearch(value: string): void {
    this.searchTerm = value;
    this.pageIndex = 0;
    this.selectedRequest = this.pagedRequests[0] || this.filteredRequests[0] || null;
  }

  updatePendingPageSize(value: string): void {
    const parsed = Number(value);
    this.pageSize = Number.isFinite(parsed) ? parsed : 10;
    this.pageIndex = 0;
    this.selectedRequest = this.pagedRequests[0] || this.filteredRequests[0] || null;
  }

  selectCompleted(record: TelebirrTransferRecord): void {
    this.selectedCompleted = record;
  }

  closeCompletedModal(): void {
    this.selectedCompleted = null;
  }

  previousCompletedPage(): void {
    if (this.completedPageIndex > 0) {
      this.completedPageIndex -= 1;
    }
  }

  nextCompletedPage(): void {
    if (this.completedPageIndex < this.totalCompletedPages - 1) {
      this.completedPageIndex += 1;
    }
  }

  updateCompletedSearch(value: string): void {
    this.completedSearchTerm = value;
    this.completedPageIndex = 0;
  }

  updateCompletedPageSize(value: string): void {
    const parsed = Number(value);
    this.completedPageSize = Number.isFinite(parsed) ? parsed : 10;
    this.completedPageIndex = 0;
  }

  statusBadge(status: string): string {
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

  private removeHandledRecord(id: number): void {
    this.requests = this.requests.filter((item) => item.id !== id);
    this.selectedRequest = this.requests[0] || null;
    this.checkerComment = '';
    this.rejectionReason = '';
    if (this.pageIndex >= this.totalPages) {
      this.pageIndex = Math.max(0, this.totalPages - 1);
    }
  }
}
