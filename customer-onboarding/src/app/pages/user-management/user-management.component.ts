import { Component, OnInit } from '@angular/core';
import { FormBuilder, Validators } from '@angular/forms';
import { forkJoin } from 'rxjs';
import {
  AdminUserListItem,
  BranchOption,
  TelebirrDashboardStats,
  UserRole
} from 'src/app/models/onboarding.models';
import { AuthService } from 'src/app/services/auth.service';
import { TelebirrTransferService } from 'src/app/services/telebirr-transfer.service';
import { ToastService } from 'src/app/services/toast.service';
import { UserManagementService } from 'src/app/services/user-management.service';

@Component({
  selector: 'app-user-management',
  templateUrl: './user-management.component.html',
  styleUrls: ['./user-management.component.css']
})
export class UserManagementComponent implements OnInit {
  readonly roles: UserRole[] = ['ADMIN', 'MAKER', 'CHECKER', 'REPORT_VIEWER', 'KYC_UNIT'];
  readonly pageSizeOptions = [10, 20, 50, 100, -1];

  loading = false;
  loadingDashboard = false;
  saving = false;
  resetting = false;
  pageError: string | null = null;
  dashboardStats: TelebirrDashboardStats | null = null;

  users: AdminUserListItem[] = [];
  branches: BranchOption[] = [];
  selectedUser: AdminUserListItem | null = null;
  searchTerm = '';
  pageIndex = 0;
  pageSize = 10;

  createForm = this.fb.group({
    username: ['', [Validators.required, Validators.minLength(3)]],
    fullName: ['', [Validators.required, Validators.minLength(3)]],
    phoneNumber: ['', [Validators.required, Validators.minLength(9)]],
    branchCode: ['', [Validators.required]],
    role: ['MAKER' as UserRole, [Validators.required]],
    password: ['', [Validators.required, Validators.minLength(8)]],
    isActive: [true]
  });

  editForm = this.fb.group({
    fullName: ['', [Validators.required, Validators.minLength(3)]],
    phoneNumber: ['', [Validators.required, Validators.minLength(9)]],
    branchCode: ['', [Validators.required]],
    role: ['MAKER' as UserRole, [Validators.required]],
    isActive: [true]
  });

  resetForm = this.fb.group({
    newPassword: ['', [Validators.required, Validators.minLength(8)]],
    forcePasswordChange: [true]
  });

  constructor(
    private fb: FormBuilder,
    private userManagement: UserManagementService,
    private telebirrTransfers: TelebirrTransferService,
    private toast: ToastService,
    private auth: AuthService
  ) {}

  ngOnInit(): void {
    this.loadAll();
  }

  get filteredUsers(): AdminUserListItem[] {
    const term = this.searchTerm.trim().toLowerCase();
    if (!term) {
      return this.users;
    }

    return this.users.filter((user) =>
      [
        user.username,
        user.fullName,
        user.phoneNumber,
        user.role,
        user.branchCode,
        user.branchName
      ].some((value) => (value || '').toString().toLowerCase().includes(term))
    );
  }

  get pagedUsers(): AdminUserListItem[] {
    if (this.pageSize === -1) {
      return this.filteredUsers;
    }

    const start = this.pageIndex * this.pageSize;
    return this.filteredUsers.slice(start, start + this.pageSize);
  }

  get totalPages(): number {
    if (this.pageSize === -1) {
      return 1;
    }
    return Math.max(1, Math.ceil(this.filteredUsers.length / this.pageSize));
  }

  get totalUsers(): number {
    return this.dashboardStats?.userStats?.totalUsers ?? this.users.length;
  }

  get activeUsers(): number {
    return this.dashboardStats?.userStats?.activeUsers ?? this.users.filter((x) => x.isActive).length;
  }

  get inactiveUsers(): number {
    return this.dashboardStats?.userStats?.inactiveUsers ?? Math.max(0, this.totalUsers - this.activeUsers);
  }

  loadAll(): void {
    this.loading = true;
    this.loadingDashboard = true;
    this.pageError = null;

    forkJoin({
      branches: this.userManagement.getBranches(),
      users: this.userManagement.getUsers(),
      stats: this.telebirrTransfers.getDashboardStats()
    }).subscribe({
      next: ({ branches, users, stats }) => {
        this.loading = false;
        this.loadingDashboard = false;
        this.branches = branches || [];
        this.users = users || [];
        this.dashboardStats = stats || null;
        this.selectedUser = this.users[0] || null;
        this.pageIndex = 0;
        if (!this.createForm.controls.branchCode.value && this.branches.length) {
          this.createForm.patchValue({ branchCode: this.branches[0].branchCode });
        }
        if (this.selectedUser) {
          this.selectUser(this.selectedUser);
        }
      },
      error: (error: any) => {
        this.loading = false;
        this.loadingDashboard = false;
        this.dashboardStats = null;
        this.pageError = error?.error?.message || error?.message || 'Unable to load user management data.';
        this.toast.error('Load failed', this.pageError || 'Load failed.');
      }
    });
  }

  createUser(): void {
    this.createForm.markAllAsTouched();
    if (this.createForm.invalid) {
      return;
    }

    this.saving = true;
    this.userManagement.createUser(this.createForm.getRawValue() as any).subscribe({
      next: (user) => {
        this.saving = false;
        this.users = [...this.users, user].sort((a, b) => a.username.localeCompare(b.username));
        this.selectedUser = user;
        this.createForm.patchValue({
          username: '',
          fullName: '',
          phoneNumber: '',
          branchCode: this.branches[0]?.branchCode || '',
          role: 'MAKER',
          password: '',
          isActive: true
        });
        this.toast.success('User created', `${user.username} was created successfully.`);
      },
      error: (error: any) => {
        this.saving = false;
        const message = error?.error?.message || error?.message || 'Unable to create user.';
        this.toast.error('Create failed', message);
      }
    });
  }

  selectUser(user: AdminUserListItem): void {
    this.selectedUser = user;
    this.editForm.patchValue({
      fullName: user.fullName,
      phoneNumber: user.phoneNumber,
      branchCode: user.branchCode,
      role: user.role,
      isActive: user.isActive
    });
    this.resetForm.patchValue({
      newPassword: '',
      forcePasswordChange: true
    });
  }

  saveSelectedUser(): void {
    if (!this.selectedUser) {
      return;
    }

    this.editForm.markAllAsTouched();
    if (this.editForm.invalid) {
      return;
    }

    this.saving = true;
    this.userManagement.updateUser(this.selectedUser.id, this.editForm.getRawValue() as any).subscribe({
      next: (updated) => {
        this.saving = false;
        this.users = this.users.map((x) => (x.id === updated.id ? updated : x));
        this.selectedUser = updated;
        this.toast.success('User updated', `${updated.username} details were updated.`);
      },
      error: (error: any) => {
        this.saving = false;
        const message = error?.error?.message || error?.message || 'Unable to update user.';
        this.toast.error('Update failed', message);
      }
    });
  }

  resetPassword(): void {
    if (!this.selectedUser) {
      return;
    }

    this.resetForm.markAllAsTouched();
    if (this.resetForm.invalid) {
      return;
    }

    this.resetting = true;
    this.userManagement.resetPassword(this.selectedUser.id, this.resetForm.getRawValue() as any).subscribe({
      next: (updated) => {
        this.resetting = false;
        this.users = this.users.map((x) => (x.id === updated.id ? updated : x));
        this.selectedUser = updated;
        this.resetForm.patchValue({ newPassword: '', forcePasswordChange: true });
        this.toast.success('Password reset', `${updated.username} password was reset successfully.`);
      },
      error: (error: any) => {
        this.resetting = false;
        const message = error?.error?.message || error?.message || 'Unable to reset password.';
        this.toast.error('Reset failed', message);
      }
    });
  }

  isCurrentSessionUser(user: AdminUserListItem): boolean {
    return this.auth.getCurrentUser()?.id === user.id;
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

  updatePageSize(value: string): void {
    const parsed = Number(value);
    this.pageSize = Number.isFinite(parsed) ? parsed : 10;
    this.pageIndex = 0;
  }

  updateSearch(value: string): void {
    this.searchTerm = value;
    this.pageIndex = 0;
  }
}
