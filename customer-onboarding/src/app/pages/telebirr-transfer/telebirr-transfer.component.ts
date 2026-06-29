import { Component, OnInit } from '@angular/core';
import { FormBuilder, Validators } from '@angular/forms';
import {
  TelebirrAccountLookupResult,
  TelebirrAgentLookupResult,
  TelebirrTransferRecord
} from 'src/app/models/onboarding.models';
import { ReceiptPrintService } from 'src/app/services/receipt-print.service';
import { TelebirrTransferService } from 'src/app/services/telebirr-transfer.service';
import { ToastService } from 'src/app/services/toast.service';

@Component({
  selector: 'app-telebirr-transfer',
  templateUrl: './telebirr-transfer.component.html',
  styleUrls: ['./telebirr-transfer.component.css']
})
export class TelebirrTransferComponent implements OnInit {
  readonly pageSizeOptions = [10, 20, 50, 100, -1];
  loadingAccount = false;
  loadingAgent = false;
  submitting = false;
  pageError: string | null = null;
  searchTerm = '';
  pageIndex = 0;
  pageSize = 10;

  accountResult: TelebirrAccountLookupResult | null = null;
  agentResult: TelebirrAgentLookupResult | null = null;
  recentRequests: TelebirrTransferRecord[] = [];

  form = this.fb.group({
    accountNumber: ['', [Validators.required, Validators.pattern(/^\d{13}$/)]],
    telebirrShortCode: ['', [Validators.required, Validators.pattern(/^\d{1,12}$/)]],
    amount: [null as number | null, [Validators.required, Validators.min(1)]],
    narration: ['']
  });

  constructor(
    private fb: FormBuilder,
    private telebirrTransfers: TelebirrTransferService,
    private toast: ToastService,
    private receiptPrinter: ReceiptPrintService
  ) {}

  ngOnInit(): void {
    this.loadRecentRequests();

    this.form.controls.accountNumber.valueChanges.subscribe(() => {
      this.accountResult = null;
    });

    this.form.controls.telebirrShortCode.valueChanges.subscribe(() => {
      this.agentResult = null;
    });
  }

  get filteredRecentRequests(): TelebirrTransferRecord[] {
    const term = this.searchTerm.trim().toLowerCase();
    if (!term) {
      return this.recentRequests;
    }

    return this.recentRequests.filter((record) =>
      [
        record.customerName,
        record.accountNumber,
        record.telebirrShortCode,
        record.telebirrOrganizationName,
        record.status
      ]
        .filter(Boolean)
        .some((value) => `${value}`.toLowerCase().includes(term))
    );
  }

  get pagedRecentRequests(): TelebirrTransferRecord[] {
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

  lookupAccount(): void {
    this.pageError = null;
    this.form.controls.accountNumber.markAsTouched();
    if (this.form.controls.accountNumber.invalid) {
      return;
    }

    this.loadingAccount = true;
    this.accountResult = null;

    this.telebirrTransfers.lookupAccount((this.form.controls.accountNumber.value || '').trim()).subscribe({
      next: (result) => {
        this.loadingAccount = false;
        this.accountResult = result;

        if (result.canProceed) {
          this.toast.success('Account verified', `${result.customerName} is ready for transfer validation.`);
          return;
        }

        this.pageError = result.message;
        this.toast.error('Account not ready', result.message);
      },
      error: (error: any) => {
        this.loadingAccount = false;
        this.pageError = error?.error?.message || error?.message || 'Unable to verify the customer account.';
        this.toast.error('Account lookup failed', this.pageError || 'Account lookup failed.');
      }
    });
  }

  lookupAgent(): void {
    this.pageError = null;
    this.form.controls.telebirrShortCode.markAsTouched();
    if (this.form.controls.telebirrShortCode.invalid) {
      return;
    }

    this.loadingAgent = true;
    this.agentResult = null;

    this.telebirrTransfers.lookupAgent((this.form.controls.telebirrShortCode.value || '').trim()).subscribe({
      next: (result) => {
        this.loadingAgent = false;
        this.agentResult = result;

        if (result.isValid) {
          this.toast.success('Agent verified', `${result.telebirrOrganizationName} is available for transfer.`);
          return;
        }

        this.pageError = result.message;
        this.toast.error('Agent verification failed', result.message);
      },
      error: (error: any) => {
        this.loadingAgent = false;
        this.pageError = error?.error?.message || error?.message || 'Unable to verify the agent code.';
        this.toast.error('Agent lookup failed', this.pageError || 'Agent lookup failed.');
      }
    });
  }

  submitTransfer(): void {
    this.pageError = null;
    this.form.markAllAsTouched();

    if (this.form.invalid) {
      return;
    }

    if (!this.accountResult?.canProceed) {
      this.pageError = 'Please verify a customer account that is ready for transfer.';
      this.toast.error('Account verification required', this.pageError);
      return;
    }

    if (!this.agentResult?.isValid) {
      this.pageError = 'Please verify the Telebirr agent code before submitting.';
      this.toast.error('Agent verification required', this.pageError);
      return;
    }

    const amount = Number(this.form.controls.amount.value || 0);
    const remainingBalance = (this.accountResult?.availableBalance || 0) - amount;
    if (remainingBalance < this.accountResult.minimumRemainingBalance) {
      this.pageError = `The remaining balance must stay above ${this.accountResult.minimumRemainingBalance.toFixed(2)} ETB.`;
      this.toast.error('Amount not allowed', this.pageError);
      return;
    }

    this.submitting = true;
    this.telebirrTransfers.submit({
      accountNumber: (this.form.controls.accountNumber.value || '').trim(),
      telebirrShortCode: (this.form.controls.telebirrShortCode.value || '').trim(),
      amount,
      narration: (this.form.controls.narration.value || '').trim()
    }).subscribe({
      next: (record) => {
        this.submitting = false;
        this.toast.success('Request submitted', `Transfer request #${record.id} is now waiting for checker review.`);
        this.recentRequests = [record, ...this.recentRequests]
          .sort((a, b) => new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime());
        this.pageIndex = 0;
        this.form.patchValue({ amount: null, narration: '' });
      },
      error: (error: any) => {
        this.submitting = false;
        this.pageError = error?.error?.message || error?.message || 'Unable to submit the transfer request.';
        this.toast.error('Submission failed', this.pageError || 'Submission failed.');
      }
    });
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

  private loadRecentRequests(): void {
    this.telebirrTransfers.getMine().subscribe({
      next: (records) => {
        this.recentRequests = [...records]
          .sort((a, b) => new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime());
        this.pageIndex = 0;
      },
      error: () => {
        this.recentRequests = [];
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

  updateSearch(value: string): void {
    this.searchTerm = value;
    this.pageIndex = 0;
  }

  updatePageSize(value: string): void {
    const parsed = Number(value);
    this.pageSize = Number.isFinite(parsed) ? parsed : 10;
    this.pageIndex = 0;
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
}
