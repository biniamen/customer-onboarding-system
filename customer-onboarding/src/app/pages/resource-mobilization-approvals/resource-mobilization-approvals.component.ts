import { Component, OnInit } from '@angular/core';
import { ResourceMobilizationRecord } from 'src/app/models/onboarding.models';
import { ResourceMobilizationService } from 'src/app/services/resource-mobilization.service';
import { ToastService } from 'src/app/services/toast.service';
import { ResourceMobilizationRecordGroup, groupResourceMobilizationRecords } from 'src/app/utils/resource-mobilization-groups';

@Component({
  selector: 'app-resource-mobilization-approvals',
  templateUrl: './resource-mobilization-approvals.component.html',
  styleUrls: ['./resource-mobilization-approvals.component.css']
})
export class ResourceMobilizationApprovalsComponent implements OnInit {
  readonly pageSizeOptions = [10, 20, 50, 100, -1];

  loading = false;
  loadingCompleted = false;
  acting = false;
  pageError: string | null = null;

  pendingRecords: ResourceMobilizationRecord[] = [];
  completedRecords: ResourceMobilizationRecord[] = [];
  selectedPendingGroup: ResourceMobilizationRecordGroup | null = null;
  selectedCompletedGroup: ResourceMobilizationRecordGroup | null = null;

  searchTerm = '';
  completedSearchTerm = '';
  pageSize = 10;
  pageIndex = 0;
  completedPageSize = 10;
  completedPageIndex = 0;

  checkerComment = '';
  rejectionReason = '';

  constructor(
    private resourceMobilization: ResourceMobilizationService,
    private toast: ToastService
  ) {}

  ngOnInit(): void {
    this.refreshAll();
  }

  get pendingGroups(): ResourceMobilizationRecordGroup[] {
    return groupResourceMobilizationRecords(this.pendingRecords);
  }

  get filteredPendingGroups(): ResourceMobilizationRecordGroup[] {
    const term = this.searchTerm.trim().toLowerCase();
    if (!term) {
      return this.pendingGroups;
    }

    return this.pendingGroups.filter((group) =>
      [
        group.groupReference,
        group.primaryRecord.depositorCustomerName,
        group.primaryRecord.depositorAccountNumber,
        group.primaryRecord.transactionReferenceNo,
        group.primaryRecord.depositProductType,
        group.primaryRecord.makerUserName,
        ...group.participantNames,
        ...group.participantReferences
      ]
        .filter(Boolean)
        .some((value) => `${value}`.toLowerCase().includes(term))
    );
  }

  get pagedPendingGroups(): ResourceMobilizationRecordGroup[] {
    if (this.pageSize === -1) {
      return this.filteredPendingGroups;
    }

    const start = this.pageIndex * this.pageSize;
    return this.filteredPendingGroups.slice(start, start + this.pageSize);
  }

  get totalPages(): number {
    if (this.pageSize === -1) {
      return 1;
    }

    return Math.max(1, Math.ceil(this.filteredPendingGroups.length / this.pageSize));
  }

  get completedGroups(): ResourceMobilizationRecordGroup[] {
    return groupResourceMobilizationRecords(this.completedRecords);
  }

  get filteredCompletedGroups(): ResourceMobilizationRecordGroup[] {
    const term = this.completedSearchTerm.trim().toLowerCase();
    if (!term) {
      return this.completedGroups;
    }

    return this.completedGroups.filter((group) =>
      [
        group.groupReference,
        group.primaryRecord.depositorCustomerName,
        group.primaryRecord.depositorAccountNumber,
        group.primaryRecord.transactionReferenceNo,
        group.primaryRecord.depositProductType,
        group.primaryRecord.makerUserName,
        group.primaryRecord.checkerUserName,
        group.status,
        ...group.participantNames,
        ...group.participantReferences
      ]
        .filter(Boolean)
        .some((value) => `${value}`.toLowerCase().includes(term))
    );
  }

  get pagedCompletedGroups(): ResourceMobilizationRecordGroup[] {
    if (this.completedPageSize === -1) {
      return this.filteredCompletedGroups;
    }

    const start = this.completedPageIndex * this.completedPageSize;
    return this.filteredCompletedGroups.slice(start, start + this.completedPageSize);
  }

  get totalCompletedPages(): number {
    if (this.completedPageSize === -1) {
      return 1;
    }

    return Math.max(1, Math.ceil(this.filteredCompletedGroups.length / this.completedPageSize));
  }

  refreshAll(): void {
    this.loadPending();
    this.loadCompleted();
  }

  loadPending(): void {
    this.loading = true;
    this.resourceMobilization.getPending().subscribe({
      next: (records) => {
        this.loading = false;
        this.pendingRecords = [...records].sort((a, b) => new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime());
        if (this.selectedPendingGroup) {
          this.selectedPendingGroup = this.pendingGroups.find((group) => group.groupReference === this.selectedPendingGroup?.groupReference) || null;
        }
      },
      error: (error: any) => {
        this.loading = false;
        this.pageError = error?.error?.message || error?.message || 'Unable to load pending approvals.';
        this.toast.error('Queue failed', this.pageError || 'Unable to load pending approvals.');
      }
    });
  }

  loadCompleted(): void {
    this.loadingCompleted = true;
    this.resourceMobilization.getCompleted().subscribe({
      next: (records) => {
        this.loadingCompleted = false;
        this.completedRecords = [...records].sort((a, b) => {
          const right = new Date(b.approvedAt || b.rejectedAt || b.updatedAt).getTime();
          const left = new Date(a.approvedAt || a.rejectedAt || a.updatedAt).getTime();
          return right - left;
        });
        if (this.selectedCompletedGroup) {
          this.selectedCompletedGroup = this.completedGroups.find((group) => group.groupReference === this.selectedCompletedGroup?.groupReference) || null;
        }
      },
      error: () => {
        this.loadingCompleted = false;
        this.completedRecords = [];
      }
    });
  }

  selectPending(group: ResourceMobilizationRecordGroup): void {
    this.selectedPendingGroup = group;
    this.checkerComment = '';
    this.rejectionReason = '';
  }

  approveSelected(): void {
    if (!this.selectedPendingGroup) {
      return;
    }

    this.acting = true;
    this.resourceMobilization.approve(this.selectedPendingGroup.primaryRecord.id, this.checkerComment.trim()).subscribe({
      next: () => {
        this.acting = false;
        this.toast.success('Approved', 'Request approved.');
        this.selectedPendingGroup = null;
        this.refreshAll();
      },
      error: (error: any) => {
        this.acting = false;
        this.toast.error('Approval failed', error?.error?.message || error?.message || 'Unable to approve the request.');
      }
    });
  }

  rejectSelected(): void {
    if (!this.selectedPendingGroup) {
      return;
    }

    const reason = this.rejectionReason.trim();
    if (!reason) {
      this.toast.info('Reason required', 'Enter a rejection reason.');
      return;
    }

    this.acting = true;
    this.resourceMobilization.reject(this.selectedPendingGroup.primaryRecord.id, reason).subscribe({
      next: () => {
        this.acting = false;
        this.toast.success('Rejected', 'Request rejected.');
        this.selectedPendingGroup = null;
        this.refreshAll();
      },
      error: (error: any) => {
        this.acting = false;
        this.toast.error('Rejection failed', error?.error?.message || error?.message || 'Unable to reject the request.');
      }
    });
  }

  updatePendingSearch(value: string): void {
    this.searchTerm = value;
    this.pageIndex = 0;
  }

  updatePendingPageSize(value: string): void {
    const parsed = Number(value);
    this.pageSize = Number.isFinite(parsed) ? parsed : 10;
    this.pageIndex = 0;
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

  openCompleted(group: ResourceMobilizationRecordGroup): void {
    this.selectedCompletedGroup = group;
  }

  closeCompletedModal(): void {
    this.selectedCompletedGroup = null;
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

  trackByGroup(index: number, group: ResourceMobilizationRecordGroup): string {
    return group.groupReference || `${group.primaryRecord.id}-${index}`;
  }
}
