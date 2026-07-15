import { Component, OnInit } from '@angular/core';
import { FormBuilder, Validators } from '@angular/forms';
import {
  RentalPaymentInquiryResult,
  RentalPaymentMode,
  RentalPaymentRecord
} from 'src/app/models/onboarding.models';
import { AuthService } from 'src/app/services/auth.service';
import { RentalPaymentService } from 'src/app/services/rental-payment.service';
import { ToastService } from 'src/app/services/toast.service';

@Component({
  selector: 'app-rental-payment',
  templateUrl: './rental-payment.component.html',
  styleUrls: ['./rental-payment.component.css']
})
export class RentalPaymentComponent implements OnInit {
  readonly pageSizeOptions = [10, 20, 50, 100, -1];
  readonly paymentModes: Array<{ value: RentalPaymentMode; title: string; description: string }> = [
    {
      value: 'ACCOUNT',
      title: 'Debit customer account',
      description: 'Use a validated 13-digit customer account as the debit side.'
    },
    {
      value: 'CASH',
      title: 'Debit branch cash GL',
      description: 'Use the branch cash GL automatically and credit the owner account.'
    }
  ];
  loadingInquiry = false;
  submitting = false;
  loadingHistory = false;
  pageError: string | null = null;
  inquiryResult: RentalPaymentInquiryResult | null = null;
  recentRequests: RentalPaymentRecord[] = [];
  searchTerm = '';
  pageIndex = 0;
  pageSize = 10;
  readonly currentBranchCode: string;

  inquiryForm = this.fb.group({
    balerId: ['', [Validators.required]],
    billId: ['', [Validators.required]]
  });

  paymentForm = this.fb.group({
    paymentMode: ['ACCOUNT' as RentalPaymentMode, [Validators.required]],
    debitAccount: ['', [Validators.required, Validators.pattern(/^\d{13}$/)]],
    paidAt: ['Branch Portal', [Validators.required, Validators.maxLength(120)]],
    tellerId: ['']
  });

  constructor(
    private fb: FormBuilder,
    private rentalPayments: RentalPaymentService,
    private toast: ToastService,
    auth: AuthService
  ) {
    this.currentBranchCode = auth.getCurrentUser()?.branchCode || '';
  }

  ngOnInit(): void {
    this.loadRecentRequests();
    this.paymentForm.controls.paymentMode.valueChanges.subscribe((mode) => {
      this.applyPaymentModeState((mode || 'ACCOUNT') as RentalPaymentMode);
    });
    this.applyPaymentModeState(this.selectedPaymentMode, true);
  }

  get filteredRecentRequests(): RentalPaymentRecord[] {
    const term = this.searchTerm.trim().toLowerCase();
    if (!term) {
      return this.recentRequests;
    }

    return this.recentRequests.filter((record) =>
      [
        record.customerName,
        record.tenantName,
        record.ownerName,
        record.billId,
        record.balerId,
        record.manifestId,
        record.cbsReference,
        record.status,
        record.debitAccount,
        record.ownerAccountNumber,
        record.paymentMode
      ]
        .filter(Boolean)
        .some((value) => `${value}`.toLowerCase().includes(term))
    );
  }

  get pagedRecentRequests(): RentalPaymentRecord[] {
    if (this.pageSize === -1) {
      return this.filteredRecentRequests;
    }

    const start = this.pageIndex * this.pageSize;
    return this.filteredRecentRequests.slice(start, start + this.pageSize);
  }

  get totalPages(): number {
    if (this.pageSize === -1) {
      return 1;
    }

    return Math.max(1, Math.ceil(this.filteredRecentRequests.length / this.pageSize));
  }

  get selectedPaymentMode(): RentalPaymentMode {
    return (this.paymentForm.controls.paymentMode.value || 'ACCOUNT') as RentalPaymentMode;
  }

  get isCashMode(): boolean {
    return this.selectedPaymentMode === 'CASH';
  }

  get isAccountMode(): boolean {
    return this.selectedPaymentMode === 'ACCOUNT';
  }

  get debitAccountControl() {
    return this.paymentForm.controls.debitAccount;
  }

  get cashGlAccount(): string {
    return this.inquiryResult?.cashDebitGlAccount || '1011010';
  }

  get debitSidePreview(): string {
    return this.isCashMode
      ? `${this.cashGlAccount} (Cash GL)`
      : ((this.debitAccountControl.value || '').trim() || 'Enter customer account');
  }

  get creditSidePreview(): string {
    return this.inquiryResult?.ownerAccountNumber || 'Waiting for owner account';
  }

  submitInquiry(): void {
    this.pageError = null;
    this.inquiryForm.markAllAsTouched();
    if (this.inquiryForm.invalid) {
      return;
    }

    this.loadingInquiry = true;
    this.inquiryResult = null;

    this.rentalPayments.inquiry(
      (this.inquiryForm.controls.billId.value || '').trim(),
      (this.inquiryForm.controls.balerId.value || '').trim()
    ).subscribe({
      next: (result) => {
        this.loadingInquiry = false;
        this.inquiryResult = result;
        this.applyPaymentModeState(this.selectedPaymentMode, false);

        if (result.canProceed) {
          this.toast.success('Pending bill loaded', `${result.customerName || result.tenantName || result.billId} is ready for payment.`);
          return;
        }

        this.pageError = result.message;
        this.toast.error('Bill not payable', result.message);
      },
      error: (error: any) => {
        this.loadingInquiry = false;
        this.pageError = error?.error?.message || error?.message || 'Unable to fetch the rental bill.';
        this.toast.error('Inquiry failed', this.pageError || 'Inquiry failed.');
      }
    });
  }

  submitPayment(): void {
    this.pageError = null;
    this.paymentForm.markAllAsTouched();
    if (this.paymentForm.controls.paidAt.invalid || (this.isAccountMode && this.debitAccountControl.invalid)) {
      return;
    }

    if (!this.inquiryResult?.canProceed || !this.inquiryResult.manifestId) {
      this.pageError = 'Please load a payable rental bill before submitting for checker approval.';
      this.toast.error('Inquiry required', this.pageError);
      return;
    }

    const formValue = this.paymentForm.getRawValue();
    this.submitting = true;
    this.rentalPayments.pay({
      manifestId: this.inquiryResult.manifestId,
      billId: this.inquiryResult.billId,
      amount: this.inquiryResult.amountDue,
      paymentMode: this.selectedPaymentMode,
      debitAccount: (formValue.debitAccount || '').trim(),
      paidAt: (formValue.paidAt || 'Branch Portal').trim(),
      tellerId: (formValue.tellerId || '').trim()
    }).subscribe({
      next: (record) => {
        this.submitting = false;
        this.toast.success('Request submitted', record.statusMessage || `Rental request status: ${record.status}.`);
        this.mergeRecord(record);
      },
      error: (error: any) => {
        this.submitting = false;
        this.pageError = error?.error?.message || error?.message || 'Unable to submit the rental payment request.';
        this.toast.error('Submission failed', this.pageError || 'Submission failed.');
      }
    });
  }

  refreshStatus(record: RentalPaymentRecord): void {
    this.rentalPayments.getStatus(record.manifestId, record.billId).subscribe({
      next: (status) => {
        const existing = this.recentRequests.find((item) => item.id === record.id);
        if (existing) {
          existing.status = status.status;
          existing.statusMessage = status.message || existing.statusMessage;
          existing.cbsReference = status.cbsReference || existing.cbsReference;
          existing.confirmationCode = status.confirmationCode || existing.confirmationCode;
          existing.paidAmount = status.paidAmount ?? existing.paidAmount;
          existing.paidAt = status.paidAt || existing.paidAt;
          existing.updatedAt = status.updatedAt;
          this.recentRequests = [...this.recentRequests];
        }

        this.toast.info('Status refreshed', status.message || `Current status: ${status.status}.`);
      },
      error: () => {
        this.toast.error('Refresh failed', 'Unable to refresh the latest rental payment status.');
      }
    });
  }

  statusClass(status: string): string {
    switch ((status || '').toUpperCase()) {
      case 'PAID':
        return 'bg-emerald-100 text-emerald-700';
      case 'UNPAID':
        return 'bg-slate-100 text-slate-700';
      case 'PENDING_CHECKER_APPROVAL':
        return 'bg-brand-100 text-brand-700';
      case 'APPROVED':
        return 'bg-emerald-100 text-emerald-700';
      case 'REJECTED':
      case 'FAILED':
        return 'bg-rose-100 text-rose-700';
      case 'CBS_POSTED_CALLBACK_PENDING':
        return 'bg-amber-100 text-amber-700';
      case 'CBS_CONFIRMATION_REQUIRED':
        return 'bg-rose-100 text-rose-700';
      case 'PROCESSING':
        return 'bg-brand-100 text-brand-700';
      default:
        return 'bg-slate-100 text-slate-700';
    }
  }

  paymentModeClass(mode: RentalPaymentMode): string {
    return this.selectedPaymentMode === mode
      ? 'border-brand-500 bg-brand-50 text-brand-800 shadow-soft'
      : 'border-slate-200 bg-white text-slate-600 hover:border-brand-300 hover:bg-brand-50/50';
  }

  paymentModeBadgeClass(mode?: string | null): string {
    return (mode || '').toUpperCase() === 'CASH'
      ? 'bg-amber-100 text-amber-700'
      : 'bg-sky-100 text-sky-700';
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

  updateSearch(value: string): void {
    this.searchTerm = value;
    this.pageIndex = 0;
  }

  updatePageSize(value: string): void {
    const parsed = Number(value);
    this.pageSize = Number.isFinite(parsed) ? parsed : 10;
    this.pageIndex = 0;
  }

  private loadRecentRequests(): void {
    this.loadingHistory = true;
    this.rentalPayments.getMine().subscribe({
      next: (records) => {
        this.loadingHistory = false;
        this.recentRequests = [...records].sort((a, b) => new Date(b.updatedAt).getTime() - new Date(a.updatedAt).getTime());
        this.pageIndex = 0;
      },
      error: () => {
        this.loadingHistory = false;
        this.recentRequests = [];
      }
    });
  }

  private mergeRecord(record: RentalPaymentRecord): void {
    this.inquiryResult = {
      ...(this.inquiryResult as RentalPaymentInquiryResult),
      manifestId: record.manifestId,
      amountDue: record.amountDue,
      baseAmount: record.baseAmount,
      penaltyAmount: record.penaltyAmount,
      ownerAccountNumber: record.ownerAccountNumber,
      message: record.statusMessage || this.inquiryResult?.message || '',
      canProceed: record.status === 'UNPAID'
    };

    const existingIndex = this.recentRequests.findIndex((item) => item.id === record.id);
    if (existingIndex >= 0) {
      this.recentRequests.splice(existingIndex, 1, record);
      this.recentRequests = [...this.recentRequests];
    } else {
      this.recentRequests = [record, ...this.recentRequests];
    }

    this.recentRequests.sort((a, b) => new Date(b.updatedAt).getTime() - new Date(a.updatedAt).getTime());
    this.pageIndex = 0;
  }

  private applyPaymentModeState(mode: RentalPaymentMode, resetAccount = false): void {
    if (mode === 'CASH') {
      this.debitAccountControl.setValue(this.cashGlAccount, { emitEvent: false });
      this.debitAccountControl.clearValidators();
      this.debitAccountControl.disable({ emitEvent: false });
      this.debitAccountControl.updateValueAndValidity({ emitEvent: false });
      return;
    }

    if (this.debitAccountControl.disabled) {
      this.debitAccountControl.enable({ emitEvent: false });
    }

    if (resetAccount || (this.debitAccountControl.value || '').trim() === this.cashGlAccount) {
      this.debitAccountControl.setValue('', { emitEvent: false });
    }

    this.debitAccountControl.setValidators([Validators.required, Validators.pattern(/^\d{13}$/)]);
    this.debitAccountControl.updateValueAndValidity({ emitEvent: false });
  }
}
