import { Component, OnInit } from '@angular/core';
import { FormBuilder, Validators } from '@angular/forms';
import { ManagedBranch } from 'src/app/models/onboarding.models';
import { ToastService } from 'src/app/services/toast.service';
import { UserManagementService } from 'src/app/services/user-management.service';

@Component({
  selector: 'app-branch-management',
  templateUrl: './branch-management.component.html',
  styleUrls: ['./branch-management.component.css']
})
export class BranchManagementComponent implements OnInit {
  readonly pageSizeOptions = [10, 20, 50, 100, -1];

  branches: ManagedBranch[] = [];
  selectedBranch: ManagedBranch | null = null;
  searchTerm = '';
  pageIndex = 0;
  pageSize = 10;
  loading = false;
  saving = false;
  deleting = false;
  pageError = '';
  modalOpen = false;
  editMode = false;

  form = this.fb.group({
    branchCode: ['', [Validators.required, Validators.pattern(/^\d{3}$/)]],
    branchName: ['', [Validators.required, Validators.minLength(3), Validators.maxLength(120)]],
    isActive: [true]
  });

  constructor(
    private fb: FormBuilder,
    private userManagement: UserManagementService,
    private toast: ToastService
  ) {}

  ngOnInit(): void {
    this.loadBranches();
  }

  get filteredBranches(): ManagedBranch[] {
    const term = this.searchTerm.trim().toLowerCase();
    if (!term) {
      return this.branches;
    }

    return this.branches.filter(branch => [branch.branchCode, branch.branchName, branch.isActive ? 'active' : 'inactive']
      .some(value => value.toLowerCase().includes(term)));
  }

  get pagedBranches(): ManagedBranch[] {
    if (this.pageSize === -1) {
      return this.filteredBranches;
    }

    const start = this.pageIndex * this.pageSize;
    return this.filteredBranches.slice(start, start + this.pageSize);
  }

  get totalPages(): number {
    return this.pageSize === -1 ? 1 : Math.max(1, Math.ceil(this.filteredBranches.length / this.pageSize));
  }

  get activeCount(): number {
    return this.branches.filter(branch => branch.isActive).length;
  }

  get inactiveCount(): number {
    return this.branches.length - this.activeCount;
  }

  loadBranches(): void {
    this.loading = true;
    this.pageError = '';
    this.userManagement.getManagedBranches().subscribe({
      next: branches => {
        this.loading = false;
        this.branches = [...(branches || [])].sort((left, right) => left.branchCode.localeCompare(right.branchCode));
        this.pageIndex = Math.min(this.pageIndex, this.totalPages - 1);
      },
      error: (error: any) => {
        this.loading = false;
        this.pageError = error?.error?.message || error?.message || 'Unable to load branches.';
        this.toast.error('Branch list unavailable', this.pageError);
      }
    });
  }

  openCreate(): void {
    this.editMode = false;
    this.selectedBranch = null;
    this.form.enable({ emitEvent: false });
    this.form.reset({ branchCode: '', branchName: '', isActive: true });
    this.modalOpen = true;
  }

  openEdit(branch: ManagedBranch): void {
    this.editMode = true;
    this.selectedBranch = branch;
    this.form.reset({
      branchCode: branch.branchCode,
      branchName: branch.branchName,
      isActive: branch.isActive
    });
    this.form.controls.branchCode.disable({ emitEvent: false });
    this.modalOpen = true;
  }

  closeModal(): void {
    if (this.saving || this.deleting) {
      return;
    }
    this.modalOpen = false;
    this.selectedBranch = null;
  }

  save(): void {
    this.form.markAllAsTouched();
    if (this.form.invalid) {
      this.toast.error('Complete required fields', 'Enter a three-digit branch code and a branch name before saving.');
      return;
    }

    const raw = this.form.getRawValue();
    this.saving = true;
    this.pageError = '';
    const request = this.editMode && this.selectedBranch
      ? this.userManagement.updateBranch(this.selectedBranch.branchCode, {
          branchName: (raw.branchName || '').trim(),
          isActive: !!raw.isActive
        })
      : this.userManagement.createBranch({
          branchCode: (raw.branchCode || '').trim(),
          branchName: (raw.branchName || '').trim()
        });

    request.subscribe({
      next: branch => {
        this.saving = false;
        this.branches = this.editMode
          ? this.branches.map(item => item.branchCode === branch.branchCode ? branch : item)
          : [...this.branches, branch];
        this.branches.sort((left, right) => left.branchCode.localeCompare(right.branchCode));
        this.toast.success(this.editMode ? 'Branch updated' : 'Branch created', `${branch.branchCode} - ${branch.branchName} is ready to use.`);
        this.closeModal();
      },
      error: (error: any) => {
        this.saving = false;
        this.pageError = error?.error?.message || error?.message || 'Unable to save the branch.';
        this.toast.error('Branch save failed', this.pageError);
      }
    });
  }

  deleteSelected(): void {
    if (!this.selectedBranch || !window.confirm(`Delete branch ${this.selectedBranch.branchCode}? This is allowed only when it has no users or onboarding records.`)) {
      return;
    }

    this.deleting = true;
    this.pageError = '';
    const branch = this.selectedBranch;
    this.userManagement.deleteBranch(branch.branchCode).subscribe({
      next: () => {
        this.deleting = false;
        this.branches = this.branches.filter(item => item.branchCode !== branch.branchCode);
        this.pageIndex = Math.min(this.pageIndex, this.totalPages - 1);
        this.toast.success('Branch deleted', `${branch.branchCode} was deleted.`);
        this.closeModal();
      },
      error: (error: any) => {
        this.deleting = false;
        this.pageError = error?.error?.message || error?.message || 'Unable to delete the branch.';
        this.toast.error('Branch deletion blocked', this.pageError);
      }
    });
  }

  updateSearch(value: string): void {
    this.searchTerm = value;
    this.pageIndex = 0;
  }

  updatePageSize(value: string): void {
    this.pageSize = Number(value) || 10;
    this.pageIndex = 0;
  }

  previousPage(): void {
    this.pageIndex = Math.max(0, this.pageIndex - 1);
  }

  nextPage(): void {
    this.pageIndex = Math.min(this.totalPages - 1, this.pageIndex + 1);
  }
}
