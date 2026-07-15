import { Component, OnInit } from '@angular/core';
import { RentalPaymentRecord } from 'src/app/models/onboarding.models';
import { RentalPaymentService } from 'src/app/services/rental-payment.service';
import { ToastService } from 'src/app/services/toast.service';

@Component({
  selector: 'app-rental-approvals',
  templateUrl: './rental-approvals.component.html',
  styleUrls: ['./rental-approvals.component.css']
})
export class RentalApprovalsComponent implements OnInit {
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

  requests: RentalPaymentRecord[] = [];
  completedRequests: RentalPaymentRecord[] = [];
  selectedRequest: RentalPaymentRecord | null = null;
  selectedCompleted: RentalPaymentRecord | null = null;
  completedSearchTerm = '';
  completedPageIndex = 0;
  completedPageSize = 10;

  constructor(
    private rentalPayments: RentalPaymentService,
    private toast: ToastService
  ) {}

  ngOnInit(): void {
    this.loadRequests();
    this.loadCompletedRequests();
  }

  get filteredRequests(): RentalPaymentRecord[] {
    const term = this.searchTerm.trim().toLowerCase();
    if (!term) {
      return this.requests;
    }

    return this.requests.filter((record) =>
      [
        record.billId,
        record.balerId,
        record.manifestId,
        record.customerName,
        record.tenantName,
        record.ownerName,
        record.ownerAccountNumber,
        record.debitAccount,
        record.paymentMode,
        record.makerUserName
      ]
        .filter(Boolean)
        .some((value) => `${value}`.toLowerCase().includes(term))
    );
  }

  get pagedRequests(): RentalPaymentRecord[] {
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

  get filteredCompletedRequests(): RentalPaymentRecord[] {
    const term = this.completedSearchTerm.trim().toLowerCase();
    if (!term) {
      return this.completedRequests;
    }

    return this.completedRequests.filter((record) =>
      [
        record.billId,
        record.balerId,
        record.manifestId,
        record.customerName,
        record.tenantName,
        record.ownerName,
        record.ownerAccountNumber,
        record.debitAccount,
        record.paymentMode,
        record.makerUserName,
        record.checkerUserName,
        record.cbsReference,
        record.status
      ]
        .filter(Boolean)
        .some((value) => `${value}`.toLowerCase().includes(term))
    );
  }

  get pagedCompletedRequests(): RentalPaymentRecord[] {
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

    this.rentalPayments.getPending().subscribe({
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
        this.pageError = error?.error?.message || error?.message || 'Unable to load pending rental payment requests.';
        this.toast.error('Queue unavailable', this.pageError || 'Queue unavailable.');
      }
    });
  }

  loadCompletedRequests(): void {
    this.loadingCompleted = true;

    this.rentalPayments.getCompleted().subscribe({
      next: (records) => {
        this.loadingCompleted = false;
        this.completedRequests = [...records].sort((a, b) =>
          new Date(b.approvedAt || b.rejectedAt || b.updatedAt).getTime() -
          new Date(a.approvedAt || a.rejectedAt || a.updatedAt).getTime()
        );
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

  selectRequest(record: RentalPaymentRecord): void {
    this.selectedRequest = record;
    this.checkerComment = '';
    this.rejectionReason = '';
  }

  approveSelected(): void {
    if (!this.selectedRequest) {
      return;
    }

    this.acting = true;
    this.rentalPayments.approve(this.selectedRequest.id, this.checkerComment.trim()).subscribe({
      next: (record) => {
        this.acting = false;
        this.toast.success('Rental request approved', record.statusMessage || 'The rental payment request was approved successfully.');
        this.removeHandledRecord(record.id);
        this.loadCompletedRequests();
      },
      error: (error: any) => {
        this.acting = false;
        const message = error?.error?.message || error?.message || 'Unable to approve the rental payment request.';
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
    this.rentalPayments.reject(this.selectedRequest.id, reason).subscribe({
      next: () => {
        this.acting = false;
        this.toast.success('Rental request rejected', 'The rental payment request was rejected successfully.');
        this.removeHandledRecord(this.selectedRequest!.id);
        this.loadCompletedRequests();
      },
      error: (error: any) => {
        this.acting = false;
        const message = error?.error?.message || error?.message || 'Unable to reject the rental payment request.';
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

  selectCompleted(record: RentalPaymentRecord): void {
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

  paymentModeBadge(mode?: string | null): string {
    return (mode || '').toUpperCase() === 'CASH'
      ? 'bg-amber-100 text-amber-700'
      : 'bg-sky-100 text-sky-700';
  }

  statusBadge(status: string): string {
    switch ((status || '').toUpperCase()) {
      case 'APPROVED':
        return 'bg-emerald-100 text-emerald-700';
      case 'REJECTED':
        return 'bg-rose-100 text-rose-700';
      case 'CBS_POSTED_CALLBACK_PENDING':
        return 'bg-amber-100 text-amber-700';
      case 'CBS_CONFIRMATION_REQUIRED':
      case 'FAILED':
        return 'bg-rose-100 text-rose-700';
      default:
        return 'bg-brand-100 text-brand-700';
    }
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
