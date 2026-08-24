import { Component, OnDestroy, OnInit } from '@angular/core';
import { FormBuilder, Validators } from '@angular/forms';
import { Subject, of } from 'rxjs';
import { catchError, debounceTime, distinctUntilChanged, finalize, switchMap, takeUntil } from 'rxjs/operators';
import {
  ResourceMobilizationEmployeeSearchResult,
  ResourceMobilizationRecord,
  ResourceMobilizationTransactionResult
} from 'src/app/models/onboarding.models';
import { ResourceMobilizationService } from 'src/app/services/resource-mobilization.service';
import { ToastService } from 'src/app/services/toast.service';
import { ResourceMobilizationRecordGroup, groupResourceMobilizationRecords } from 'src/app/utils/resource-mobilization-groups';

@Component({
  selector: 'app-resource-mobilization',
  templateUrl: './resource-mobilization.component.html',
  styleUrls: ['./resource-mobilization.component.css']
})
export class ResourceMobilizationComponent implements OnInit, OnDestroy {
  readonly pageSizeOptions = [10, 20, 50, 100, -1];
  readonly employeeSearchLimit = 80;
  readonly registrationModes = [
    { value: 'SINGLE', label: 'Single', note: 'Register one mobilizer.' },
    { value: 'JOINT', label: 'Joint', note: 'Split one deposit across 2 or 3 mobilizers.' }
  ] as const;
  readonly productTypes = [
    { value: 'DEMAND', title: 'Demand', description: 'Use for current or demand deposit products.' },
    { value: 'SAVING', title: 'Saving', description: 'Use for ordinary saving-led deposit mobilization.' },
    { value: 'IFB', title: 'IFB', description: 'Use for Islamic or IFB deposit mobilization.' }
  ];
  readonly historyTabs = [
    { value: 'register', label: 'Registration Workspace' },
    { value: 'history', label: 'My Registrations' }
  ] as const;

  employeeSearchTerm = '';
  employeeMatches: ResourceMobilizationEmployeeSearchResult[] = [];
  selectedEmployees: ResourceMobilizationEmployeeSearchResult[] = [];
  activeTab: 'register' | 'history' = 'register';
  registrationMode: 'SINGLE' | 'JOINT' = 'SINGLE';

  transactionMatches: ResourceMobilizationTransactionResult[] = [];
  selectedTransaction: ResourceMobilizationTransactionResult | null = null;

  loadingEmployees = false;
  loadingTransactions = false;
  loadingHistory = false;
  submitting = false;
  pageError: string | null = null;
  existingRegistrationStatus: {
    existingRecordId?: number | null;
    existingRegistrationReference?: string | null;
    existingStatus?: string | null;
    existingEmployeeReference?: string | null;
    existingEmployeeFullName?: string | null;
    createdAt?: string | null;
  } | null = null;

  recentRecords: ResourceMobilizationRecord[] = [];
  selectedRecordGroup: ResourceMobilizationRecordGroup | null = null;
  searchTerm = '';
  pageIndex = 0;
  pageSize = 10;

  readonly employeeSearch$ = new Subject<string>();
  private readonly destroy$ = new Subject<void>();

  transactionSearchForm = this.fb.group({
    transactionReferenceNo: [''],
    accountNumber: ['', [Validators.pattern(/^\d{10,20}$/)]],
    fromDate: [''],
    toDate: ['']
  });

  campaignForm = this.fb.group({
    monthlyTargetAmount: [0, [Validators.required, Validators.min(0)]],
    depositProductType: ['SAVING', [Validators.required]],
    newAccountCount: [0, [Validators.required, Validators.min(0)]],
    depositorCustomerName: [{ value: '', disabled: true }, [Validators.required, Validators.maxLength(220)]]
  });

  constructor(
    private fb: FormBuilder,
    private resourceMobilization: ResourceMobilizationService,
    private toast: ToastService
  ) {}

  ngOnInit(): void {
    this.loadHistory();

    this.employeeSearch$
      .pipe(
        debounceTime(320),
        distinctUntilChanged(),
        switchMap((term) => {
          const keyword = term.trim();
          if (keyword.length < 2) {
            this.employeeMatches = [];
            this.loadingEmployees = false;
            return of<ResourceMobilizationEmployeeSearchResult[]>([]);
          }

          this.loadingEmployees = true;
          return this.resourceMobilization.searchEmployees(keyword, this.employeeSearchLimit).pipe(
            catchError((error: any) => {
              this.toast.error('Search failed', error?.error?.message || error?.message || 'Unable to search employees.');
              return of<ResourceMobilizationEmployeeSearchResult[]>([]);
            }),
            finalize(() => {
              this.loadingEmployees = false;
            })
          );
        }),
        takeUntil(this.destroy$)
      )
      .subscribe((items) => {
        this.employeeMatches = items || [];
      });
  }

  ngOnDestroy(): void {
    this.destroy$.next();
    this.destroy$.complete();
    this.employeeSearch$.complete();
  }

  get isJointMode(): boolean {
    return this.registrationMode === 'JOINT';
  }

  get selectedEmployee(): ResourceMobilizationEmployeeSearchResult | null {
    return this.selectedEmployees[0] || null;
  }

  get selectedEmployeeCount(): number {
    return this.selectedEmployees.length;
  }

  get selectedProductType(): string {
    return this.campaignForm.controls.depositProductType.value || 'SAVING';
  }

  get hasExistingEmployeeProfile(): boolean {
    return !this.isJointMode && !!this.selectedEmployee?.hasExistingRegistration;
  }

  get shouldCaptureEmployeeProfile(): boolean {
    if (this.isJointMode) {
      return true;
    }

    return !!this.selectedEmployee && !this.hasExistingEmployeeProfile;
  }

  get selectedMonthlyTargetAmount(): number {
    if (this.hasExistingEmployeeProfile) {
      return Number(this.selectedEmployee?.existingMonthlyTargetAmount || 0);
    }

    return Number(this.campaignForm.controls.monthlyTargetAmount.value || 0);
  }

  get selectedNewAccountCount(): number {
    if (this.hasExistingEmployeeProfile) {
      return Number(this.selectedEmployee?.existingNewAccountCount || 0);
    }

    return Number(this.campaignForm.controls.newAccountCount.value || 0);
  }

  get employeeSearchHasValue(): boolean {
    return this.employeeSearchTerm.trim().length >= 2;
  }

  get totalRegistrations(): number {
    return this.recentRecordGroups.length;
  }

  get pendingRegistrations(): number {
    return this.recentRecordGroups.filter((group) => (group.status || '').toUpperCase() === 'PENDING_CHECKER_APPROVAL').length;
  }

  get approvedRegistrations(): number {
    return this.recentRecordGroups.filter((group) => (group.status || '').toUpperCase() === 'APPROVED').length;
  }

  get rejectedRegistrations(): number {
    return this.recentRecordGroups.filter((group) => (group.status || '').toUpperCase() === 'REJECTED').length;
  }

  get totalFilteredRecords(): number {
    return this.filteredRecordGroups.length;
  }

  get pageStartRecord(): number {
    if (!this.filteredRecordGroups.length) {
      return 0;
    }

    if (this.pageSize === -1) {
      return 1;
    }

    return this.pageIndex * this.pageSize + 1;
  }

  get pageEndRecord(): number {
    if (!this.filteredRecordGroups.length) {
      return 0;
    }

    if (this.pageSize === -1) {
      return this.filteredRecordGroups.length;
    }

    return Math.min((this.pageIndex + 1) * this.pageSize, this.filteredRecordGroups.length);
  }

  get recentRecordGroups(): ResourceMobilizationRecordGroup[] {
    return groupResourceMobilizationRecords(this.recentRecords);
  }

  get latestRecordsPreview(): ResourceMobilizationRecordGroup[] {
    return this.recentRecordGroups.slice(0, 4);
  }

  get filteredRecordGroups(): ResourceMobilizationRecordGroup[] {
    const term = this.searchTerm.trim().toLowerCase();
    if (!term) {
      return this.recentRecordGroups;
    }

    return this.recentRecordGroups.filter((group) =>
      [
        group.groupReference,
        group.primaryRecord.depositProductType,
        group.primaryRecord.status,
        group.primaryRecord.depositorCustomerName,
        group.primaryRecord.depositorAccountNumber,
        group.primaryRecord.transactionReferenceNo,
        group.primaryRecord.depositBranchCode,
        group.primaryRecord.depositBranchName,
        ...group.participantNames,
        ...group.participantReferences
      ]
        .filter(Boolean)
        .some((value) => `${value}`.toLowerCase().includes(term))
    );
  }

  get pagedRecordGroups(): ResourceMobilizationRecordGroup[] {
    if (this.pageSize === -1) {
      return this.filteredRecordGroups;
    }

    const start = this.pageIndex * this.pageSize;
    return this.filteredRecordGroups.slice(start, start + this.pageSize);
  }

  get totalPages(): number {
    if (this.pageSize === -1) {
      return 1;
    }

    return Math.max(1, Math.ceil(this.filteredRecordGroups.length / this.pageSize));
  }

  get selectedTransactionAmount(): number {
    return Number(this.selectedTransaction?.amount || 0);
  }

  get selectedEmployeeNamesDisplay(): string {
    return this.selectedEmployees.length
      ? this.selectedEmployees.map((employee) => employee.fullName).join(', ')
      : 'Select employee first';
  }

  get sourceAmountDisplay(): number {
    return this.selectedTransactionAmount || Number(this.selectedRecordGroup?.sourceTransactionAmount || 0);
  }

  get splitAmountPreview(): number {
    if (!this.isJointMode || this.selectedEmployeeCount <= 0) {
      return this.selectedTransactionAmount;
    }

    return this.selectedTransactionAmount / this.selectedEmployeeCount;
  }

  get remainingJointSlots(): number {
    return Math.max(0, 3 - this.selectedEmployeeCount);
  }

  setActiveTab(tab: 'register' | 'history'): void {
    this.activeTab = tab;
  }

  setRegistrationMode(mode: 'SINGLE' | 'JOINT'): void {
    if (this.registrationMode === mode) {
      return;
    }

    this.registrationMode = mode;
    this.clearEmployee();
  }

  onEmployeeSearchChange(value: string): void {
    this.employeeSearchTerm = value;
    this.employeeSearch$.next(value);
  }

  selectEmployee(item: ResourceMobilizationEmployeeSearchResult): void {
    const alreadySelected = this.selectedEmployees.some((employee) => employee.id === item.id);
    if (alreadySelected) {
      this.toast.info('Already selected', 'This employee is already in the request.');
      this.employeeSearchTerm = '';
      this.employeeMatches = [];
      return;
    }

    if (this.isJointMode) {
      if (this.selectedEmployees.length >= 3) {
        this.toast.info('Joint limit', 'Select up to 3 employees only.');
        return;
      }

      this.selectedEmployees = [...this.selectedEmployees, item];
      this.employeeSearchTerm = '';
      this.employeeMatches = [];
      this.syncCampaignFieldsForSelection();
      return;
    }

    this.selectedEmployees = [item];
    this.employeeSearchTerm = `${item.fullName} | ${item.employeeReference}`;
    this.employeeMatches = [];
    this.syncCampaignFieldsForSelection();
  }

  removeSelectedEmployee(employeeId: string): void {
    this.selectedEmployees = this.selectedEmployees.filter((employee) => employee.id !== employeeId);
    this.syncCampaignFieldsForSelection();
  }

  clearEmployee(): void {
    this.selectedEmployees = [];
    this.employeeSearchTerm = '';
    this.employeeMatches = [];
    this.syncCampaignFieldsForSelection();
  }

  searchTransactions(): void {
    this.pageError = null;
    this.existingRegistrationStatus = null;
    const raw = this.transactionSearchForm.getRawValue();
    const transactionReferenceNo = (raw.transactionReferenceNo || '').trim();
    const accountNumber = (raw.accountNumber || '').trim();

    if (!transactionReferenceNo && !accountNumber) {
      this.toast.info('Search needed', 'Enter a transaction reference or account number.');
      return;
    }

    if (this.transactionSearchForm.controls.accountNumber.invalid) {
      this.transactionSearchForm.controls.accountNumber.markAsTouched();
      return;
    }

    this.loadingTransactions = true;
    this.selectedTransaction = null;
    this.transactionMatches = [];

    this.resourceMobilization.searchTransactions({
      transactionReferenceNo,
      accountNumber,
      fromDate: raw.fromDate ? new Date(`${raw.fromDate}T00:00:00`).toISOString() : undefined,
      toDate: raw.toDate ? new Date(`${raw.toDate}T23:59:59.999`).toISOString() : undefined,
      limit: 20
    }).subscribe({
      next: (items) => {
        this.loadingTransactions = false;
        this.transactionMatches = items || [];
        if (!this.transactionMatches.length) {
          this.toast.info('No matches', 'No CBS deposit was found.');
        }
      },
      error: (error: any) => {
        this.loadingTransactions = false;
        if (error?.status === 409) {
          this.existingRegistrationStatus = {
            existingRecordId: error?.error?.existingRecordId,
            existingRegistrationReference: error?.error?.existingRegistrationReference || error?.error?.registrationReference,
            existingStatus: error?.error?.existingStatus,
            existingEmployeeReference: error?.error?.existingEmployeeReference,
            existingEmployeeFullName: error?.error?.existingEmployeeFullName || error?.error?.existingEmployee,
            createdAt: error?.error?.createdAt || null
          };
          this.toast.info('Already registered', error?.error?.message || 'This deposit is already registered.');
          return;
        }

        this.pageError = error?.error?.message || error?.message || 'Unable to search deposit transactions.';
        this.toast.error('Search failed', this.pageError || 'Unable to search deposit transactions.');
      }
    });
  }

  selectTransaction(item: ResourceMobilizationTransactionResult): void {
    if (item.alreadyRegistered) {
      this.existingRegistrationStatus = {
        existingRecordId: item.existingRecordId,
        existingRegistrationReference: item.existingRegistrationReference,
        existingStatus: item.existingStatus,
        existingEmployeeReference: item.existingEmployeeReference,
        existingEmployeeFullName: item.existingEmployeeFullName
      };
      this.toast.info('Already registered', 'This deposit is already linked.');
      return;
    }

    this.selectedTransaction = item;
    this.campaignForm.patchValue({
      depositorCustomerName: item.customerName || '',
      depositProductType: item.suggestedProductType || 'SAVING'
    });
  }

  submit(): void {
    this.pageError = null;
    this.campaignForm.markAllAsTouched();
    if (this.campaignForm.invalid) {
      return;
    }

    if (!this.selectedEmployees.length) {
      this.toast.info('Select employee', this.isJointMode ? 'Select 2 or 3 employees first.' : 'Select an employee first.');
      return;
    }

    if (!this.isJointMode && this.selectedEmployees.length !== 1) {
      this.toast.info('Single request', 'Select only one employee for a single request.');
      return;
    }

    if (this.isJointMode && (this.selectedEmployees.length < 2 || this.selectedEmployees.length > 3)) {
      this.toast.info('Joint selection', 'Select 2 or 3 employees for joint registration.');
      return;
    }

    if (!this.selectedTransaction) {
      this.toast.info('Select deposit', 'Choose the CBS deposit first.');
      return;
    }

    if (this.selectedTransaction.alreadyRegistered) {
      this.toast.info('Already registered', 'This deposit is already linked.');
      return;
    }

    const raw = this.campaignForm.getRawValue();
    const selectedEmployeeIds = this.selectedEmployees.map((employee) => employee.id);

    this.submitting = true;
    this.resourceMobilization.submit({
      employeeDirectoryEntryId: selectedEmployeeIds[0],
      employeeDirectoryEntryIds: selectedEmployeeIds,
      isJointRegistration: this.isJointMode,
      monthlyTargetAmount: Number(raw.monthlyTargetAmount || 0),
      depositProductType: raw.depositProductType || 'SAVING',
      newAccountCount: Number(raw.newAccountCount || 0),
      transactionReferenceNo: this.selectedTransaction.transactionReferenceNo,
      accountNumber: this.selectedTransaction.accountNumber,
      depositorCustomerName: (this.selectedTransaction.customerName || raw.depositorCustomerName || '').trim()
    }).subscribe({
      next: () => {
        this.submitting = false;
        this.toast.success('Submitted', 'Request sent to checker.');
        this.resetEntryState();
        this.loadHistory();
      },
      error: (error: any) => {
        this.submitting = false;
        this.pageError = error?.error?.message || error?.message || 'Unable to submit the resource mobilization record.';
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
      default:
        return 'bg-brand-100 text-brand-700';
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

  openRecord(group: ResourceMobilizationRecordGroup): void {
    this.selectedRecordGroup = group;
  }

  exportHistory(): void {
    const rows = this.filteredRecordGroups;
    const headers = [
      'Request Reference',
      'Mode',
      'Participants',
      'Depositor Name',
      'Account Number',
      'Transaction Reference',
      'Product',
      'Total Deposit',
      'Employee Share Total',
      'Deposit Branch',
      'Status',
      'Submitted'
    ];

    const csvRows = rows.map((group) => [
      group.groupReference,
      group.isJointRegistration ? `JOINT (${group.jointParticipantCount})` : 'SINGLE',
      group.participantNames.join(' | '),
      group.primaryRecord.depositorCustomerName,
      group.primaryRecord.depositorAccountNumber,
      group.primaryRecord.transactionReferenceNo,
      group.primaryRecord.depositProductType,
      this.formatMoney(group.sourceTransactionAmount),
      this.formatMoney(group.splitAmountTotal),
      `${group.primaryRecord.depositBranchCode || ''}${group.primaryRecord.depositBranchName ? ' - ' + group.primaryRecord.depositBranchName : ''}`,
      group.status,
      new Date(group.primaryRecord.createdAt).toLocaleString()
    ]);

    const csvContent = [headers, ...csvRows]
      .map((row) => row.map((value) => `"${String(value ?? '').replace(/"/g, '""')}"`).join(','))
      .join('\r\n');

    this.downloadFile(csvContent, `resource-mobilization-my-registrations-${this.buildFileDateStamp()}.csv`, 'text/csv;charset=utf-8;');
    this.toast.success('Export ready', 'Filtered requests downloaded.');
  }

  closeRecordModal(): void {
    this.selectedRecordGroup = null;
  }

  productMarker(record: ResourceMobilizationRecord, productType: string): string {
    return record.depositProductType.toUpperCase() === productType ? 'Yes' : '-';
  }

  isEmployeeSelected(employeeId: string): boolean {
    return this.selectedEmployees.some((employee) => employee.id === employeeId);
  }

  trackByEmployee(index: number, employee: ResourceMobilizationEmployeeSearchResult): string {
    return employee.id || `${employee.employeeReference}-${index}`;
  }

  trackByGroup(index: number, group: ResourceMobilizationRecordGroup): string {
    return group.groupReference || `${group.primaryRecord.id}-${index}`;
  }

  private loadHistory(): void {
    this.loadingHistory = true;
    this.resourceMobilization.getMine().subscribe({
      next: (records) => {
        this.loadingHistory = false;
        this.recentRecords = [...records].sort((a, b) => new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime());
        if (this.selectedRecordGroup) {
          this.selectedRecordGroup = this.recentRecordGroups.find((group) => group.groupReference === this.selectedRecordGroup?.groupReference) || null;
        }
      },
      error: () => {
        this.loadingHistory = false;
        this.recentRecords = [];
      }
    });
  }

  private resetEntryState(): void {
    this.registrationMode = 'SINGLE';
    this.clearEmployee();
    this.transactionMatches = [];
    this.selectedTransaction = null;
    this.existingRegistrationStatus = null;
    this.transactionSearchForm.reset({
      transactionReferenceNo: '',
      accountNumber: '',
      fromDate: '',
      toDate: ''
    });
    this.campaignForm.reset({
      monthlyTargetAmount: 0,
      depositProductType: 'SAVING',
      newAccountCount: 0,
      depositorCustomerName: ''
    });
  }

  private syncCampaignFieldsForSelection(): void {
    if (this.isJointMode) {
      this.campaignForm.patchValue({
        monthlyTargetAmount: 0,
        newAccountCount: 0
      });
      return;
    }

    if (this.selectedEmployee?.hasExistingRegistration) {
      this.campaignForm.patchValue({
        monthlyTargetAmount: Number(this.selectedEmployee.existingMonthlyTargetAmount || 0),
        newAccountCount: Number(this.selectedEmployee.existingNewAccountCount || 0)
      });
      return;
    }

    this.campaignForm.patchValue({
      monthlyTargetAmount: 0,
      newAccountCount: 0
    });
  }

  private formatMoney(value?: number | null): string {
    return Number(value || 0).toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 });
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
