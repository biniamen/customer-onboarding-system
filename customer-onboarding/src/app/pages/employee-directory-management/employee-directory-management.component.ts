import { Component, OnInit } from '@angular/core';
import { FormBuilder, Validators } from '@angular/forms';
import {
  EmployeeDirectoryEntryRecord,
  EmployeeDirectoryPagedResponse,
  UpdateEmployeeDirectoryEntryRequest
} from 'src/app/models/onboarding.models';
import { PasswordManagementService } from 'src/app/services/password-management.service';
import { ToastService } from 'src/app/services/toast.service';

@Component({
  selector: 'app-employee-directory-management',
  templateUrl: './employee-directory-management.component.html',
  styleUrls: ['./employee-directory-management.component.css']
})
export class EmployeeDirectoryManagementComponent implements OnInit {
  readonly pageSizeOptions = [10, 20, 50, 100, -1];
  readonly activeOptions = [
    { value: '', label: 'All records' },
    { value: 'true', label: 'Active only' },
    { value: 'false', label: 'Inactive only' }
  ];

  loading = false;
  saving = false;
  deleting = false;
  pageError: string | null = null;

  records: EmployeeDirectoryEntryRecord[] = [];
  selectedRecord: EmployeeDirectoryEntryRecord | null = null;

  searchTerm = '';
  activeFilter = '';
  pageSize = 20;
  currentPage = 1;
  totalPages = 1;
  totalRecords = 0;

  editForm = this.fb.group({
    sequenceNumber: [null as number | null],
    employeeReference: ['', [Validators.required, Validators.maxLength(96)]],
    employeeCode: ['', [Validators.maxLength(32)]],
    internalNumber: ['', [Validators.maxLength(32)]],
    internalNumberExtension: ['', [Validators.maxLength(32)]],
    firstName: ['', [Validators.maxLength(80)]],
    middleName: ['', [Validators.maxLength(120)]],
    lastName: ['', [Validators.maxLength(80)]],
    fullEmployeeName: ['', [Validators.required, Validators.maxLength(220)]],
    gender: ['', [Validators.maxLength(16)]],
    contactAddress: ['', [Validators.maxLength(120)]],
    phoneNumber: ['', [Validators.required, Validators.maxLength(32)]],
    currentPosition: ['', [Validators.maxLength(220)]],
    classification: ['', [Validators.maxLength(80)]],
    assignedUnitName: ['', [Validators.maxLength(220)]],
    branchGrade: ['', [Validators.maxLength(80)]],
    branchCode: ['', [Validators.required, Validators.maxLength(32)]],
    district: ['', [Validators.maxLength(80)]],
    employmentDate: [''],
    isActive: [true]
  });

  constructor(
    private fb: FormBuilder,
    private passwordManagement: PasswordManagementService,
    private toast: ToastService
  ) {}

  ngOnInit(): void {
    this.loadEmployees();
  }

  loadEmployees(): void {
    this.loading = true;
    this.pageError = null;

    this.passwordManagement.getEmployeeDirectory({
      search: this.searchTerm.trim(),
      isActive: this.activeFilter === '' ? undefined : this.activeFilter === 'true',
      page: this.currentPage,
      pageSize: this.pageSize
    }).subscribe({
      next: (response: EmployeeDirectoryPagedResponse) => {
        this.loading = false;
        this.records = response.items || [];
        this.totalRecords = response.totalRecords || 0;
        this.totalPages = response.totalPages || 1;
        this.currentPage = response.page || 1;

        if (this.selectedRecord) {
          const latest = this.records.find((item) => item.id === this.selectedRecord?.id);
          if (latest) {
            this.selectRecord(latest);
          }
        }
      },
      error: (error: any) => {
        this.loading = false;
        this.pageError = error?.error?.message || error?.message || 'Unable to load employee records.';
        this.toast.error('Load failed', this.pageError || 'Load failed.');
      }
    });
  }

  applyFilters(): void {
    this.currentPage = 1;
    this.loadEmployees();
  }

  clearFilters(): void {
    this.searchTerm = '';
    this.activeFilter = '';
    this.pageSize = 20;
    this.currentPage = 1;
    this.loadEmployees();
  }

  changePage(page: number): void {
    if (page < 1 || page > this.totalPages || page === this.currentPage) {
      return;
    }

    this.currentPage = page;
    this.loadEmployees();
  }

  updatePageSize(value: string | number): void {
    const parsed = Number(value);
    this.pageSize = Number.isFinite(parsed) ? parsed : 20;
    this.currentPage = 1;
    this.loadEmployees();
  }

  selectRecord(record: EmployeeDirectoryEntryRecord): void {
    this.selectedRecord = record;
    this.editForm.patchValue({
      sequenceNumber: record.sequenceNumber ?? null,
      employeeReference: record.employeeReference,
      employeeCode: record.employeeCode,
      internalNumber: record.internalNumber,
      internalNumberExtension: record.internalNumberExtension,
      firstName: record.firstName,
      middleName: record.middleName,
      lastName: record.lastName,
      fullEmployeeName: record.fullEmployeeName,
      gender: record.gender,
      contactAddress: record.contactAddress,
      phoneNumber: record.phoneNumber,
      currentPosition: record.currentPosition,
      classification: record.classification,
      assignedUnitName: record.assignedUnitName,
      branchGrade: record.branchGrade,
      branchCode: record.branchCode,
      district: record.district,
      employmentDate: record.employmentDate || '',
      isActive: record.isActive
    });
  }

  closeEditor(): void {
    this.selectedRecord = null;
  }

  save(): void {
    if (!this.selectedRecord) {
      return;
    }

    this.editForm.markAllAsTouched();
    if (this.editForm.invalid) {
      return;
    }

    const raw = this.editForm.getRawValue();
    const payload: UpdateEmployeeDirectoryEntryRequest = {
      sequenceNumber: raw.sequenceNumber,
      employeeReference: raw.employeeReference || '',
      employeeCode: raw.employeeCode || '',
      internalNumber: raw.internalNumber || '',
      internalNumberExtension: raw.internalNumberExtension || '',
      firstName: raw.firstName || '',
      middleName: raw.middleName || '',
      lastName: raw.lastName || '',
      fullEmployeeName: raw.fullEmployeeName || '',
      gender: raw.gender || '',
      contactAddress: raw.contactAddress || '',
      phoneNumber: raw.phoneNumber || '',
      currentPosition: raw.currentPosition || '',
      classification: raw.classification || '',
      assignedUnitName: raw.assignedUnitName || '',
      branchGrade: raw.branchGrade || '',
      branchCode: raw.branchCode || '',
      district: raw.district || '',
      employmentDate: raw.employmentDate || null,
      isActive: !!raw.isActive
    };

    this.saving = true;
    this.passwordManagement.updateEmployeeDirectoryEntry(this.selectedRecord.id, payload).subscribe({
      next: (updated) => {
        this.saving = false;
        this.toast.success('Employee updated', `${updated.fullEmployeeName} was updated successfully.`);
        this.selectedRecord = updated;
        this.records = this.records.map((item) => item.id === updated.id ? updated : item);
        this.selectRecord(updated);
      },
      error: (error: any) => {
        this.saving = false;
        this.toast.error('Update failed', error?.error?.message || error?.message || 'Unable to update employee.');
      }
    });
  }

  deleteSelected(): void {
    if (!this.selectedRecord) {
      return;
    }

    if (!window.confirm(`Delete employee record ${this.selectedRecord.fullEmployeeName}?`)) {
      return;
    }

    this.deleting = true;
    const deletingId = this.selectedRecord.id;
    this.passwordManagement.deleteEmployeeDirectoryEntry(deletingId).subscribe({
      next: () => {
        this.deleting = false;
        this.toast.success('Employee deleted', 'The employee record was deleted successfully.');
        this.closeEditor();

        if (this.records.length === 1 && this.currentPage > 1) {
          this.currentPage -= 1;
        }

        this.loadEmployees();
      },
      error: (error: any) => {
        this.deleting = false;
        this.toast.error('Delete failed', error?.error?.message || error?.message || 'Unable to delete employee.');
      }
    });
  }
}
