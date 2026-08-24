import { Component, OnDestroy, OnInit } from '@angular/core';
import { FormBuilder, Validators } from '@angular/forms';
import { Subject, of } from 'rxjs';
import { catchError, debounceTime, distinctUntilChanged, finalize, switchMap, takeUntil } from 'rxjs/operators';
import {
  EmployeeDirectoryImportResult,
  EmployeeDirectoryStats,
  ExternalDirectoryUser,
  PasswordMessageDispatchResult
} from 'src/app/models/onboarding.models';
import { PasswordManagementService } from 'src/app/services/password-management.service';
import { ToastService } from 'src/app/services/toast.service';

@Component({
  selector: 'app-password-management',
  templateUrl: './password-management.component.html',
  styleUrls: ['./password-management.component.css']
})
export class PasswordManagementComponent implements OnInit, OnDestroy {
  readonly minimumSearchLength = 2;
  readonly resultLimit = 20;
  readonly passwordSystems = [
    'Flexcube Core banking',
    'Check Point System',
    'Webmail',
    'BI Report'
  ];

  loadingUsers = false;
  loadingDirectoryStats = false;
  importingDirectory = false;
  sendingReset = false;
  sendingNewUser = false;
  pageError: string | null = null;

  searchTerm = '';
  users: ExternalDirectoryUser[] = [];
  selectedUser: ExternalDirectoryUser | null = null;
  lastDispatch: PasswordMessageDispatchResult | null = null;
  directoryStats: EmployeeDirectoryStats | null = null;
  lastImportResult: EmployeeDirectoryImportResult | null = null;
  selectedDirectoryFile: File | null = null;

  resetForm = this.fb.group({
    systemName: ['', [Validators.required]],
    password: ['', [Validators.required, Validators.minLength(8)]]
  });

  newUserForm = this.fb.group({
    systemName: ['', [Validators.required]],
    username: ['', [Validators.required, Validators.minLength(3)]],
    password: ['', [Validators.required, Validators.minLength(8)]]
  });

  private readonly searchTerm$ = new Subject<string>();
  private readonly destroy$ = new Subject<void>();

  constructor(
    private fb: FormBuilder,
    private passwordManagement: PasswordManagementService,
    private toast: ToastService
  ) {}

  ngOnInit(): void {
    this.loadEmployeeDirectoryStats();

    this.searchTerm$
      .pipe(
        debounceTime(320),
        distinctUntilChanged(),
        switchMap((term) => {
          const keyword = term.trim();

          if (!keyword) {
            this.pageError = null;
            this.users = [];
            this.loadingUsers = false;
            return of<ExternalDirectoryUser[]>([]);
          }

          if (keyword.length < this.minimumSearchLength) {
            this.pageError = null;
            this.users = [];
            this.loadingUsers = false;
            return of<ExternalDirectoryUser[]>([]);
          }

          this.loadingUsers = true;
          this.pageError = null;

          return this.passwordManagement.getExternalUsers(keyword, this.resultLimit).pipe(
            catchError((error: any) => {
              this.pageError = error?.error?.message || error?.message || 'Unable to search the employee directory.';
              this.toast.error('Search failed', this.pageError || 'Search failed.');
              return of<ExternalDirectoryUser[]>([]);
            }),
            finalize(() => {
              this.loadingUsers = false;
            })
          );
        }),
        takeUntil(this.destroy$)
      )
      .subscribe((users) => {
        this.users = users || [];
      });
  }

  ngOnDestroy(): void {
    this.destroy$.next();
    this.destroy$.complete();
    this.searchTerm$.complete();
  }

  get userInitials(): string {
    if (!this.selectedUser) {
      return 'PM';
    }

    const parts = this.selectedUser.fullEmployeeName.split(' ').filter(Boolean);
    return parts.slice(0, 2).map((part) => part[0]?.toUpperCase() || '').join('') || 'PM';
  }

  get hasSearchKeyword(): boolean {
    return this.searchTerm.trim().length >= this.minimumSearchLength;
  }

  get searchPrompt(): string {
    const keyword = this.searchTerm.trim();
    if (!keyword) {
      return 'Type a name, reference, phone number, or branch.';
    }

    if (keyword.length < this.minimumSearchLength) {
      return `Type at least ${this.minimumSearchLength} characters to start the search.`;
    }

    if (this.loadingUsers) {
      return 'Searching employee directory...';
    }

    if (!this.users.length) {
      return 'No matching employees found.';
    }

    return `Showing up to ${this.resultLimit} matches.`;
  }

  onSearchTermChange(term: string): void {
    this.searchTerm = term;

    if (this.selectedUser && this.formatSelectedUserLabel(this.selectedUser) !== term.trim()) {
      this.selectedUser = null;
      this.lastDispatch = null;
    }

    this.searchTerm$.next(term);
  }

  refreshSearch(): void {
    this.searchTerm$.next(this.searchTerm);
  }

  selectUser(user: ExternalDirectoryUser): void {
    this.selectedUser = user;
    this.searchTerm = this.formatSelectedUserLabel(user);
    this.users = [];
    this.lastDispatch = null;
    this.resetForm.reset({ systemName: '', password: '' });
    this.newUserForm.reset({ systemName: '', username: '', password: '' });
  }

  clearSelection(): void {
    this.selectedUser = null;
    this.searchTerm = '';
    this.users = [];
    this.lastDispatch = null;
    this.pageError = null;
  }

  loadEmployeeDirectoryStats(): void {
    this.loadingDirectoryStats = true;
    this.passwordManagement.getEmployeeDirectoryStats().subscribe({
      next: (stats) => {
        this.loadingDirectoryStats = false;
        this.directoryStats = stats;
      },
      error: () => {
        this.loadingDirectoryStats = false;
      }
    });
  }

  onDirectoryFileSelected(event: Event): void {
    const input = event.target as HTMLInputElement;
    const file = input.files && input.files.length ? input.files[0] : null;
    this.selectedDirectoryFile = file;
  }

  importEmployeeDirectory(): void {
    if (!this.selectedDirectoryFile) {
      this.toast.info('Choose a workbook', 'Select the employee Excel workbook first.');
      return;
    }

    this.importingDirectory = true;
    this.passwordManagement.importEmployeeDirectory(this.selectedDirectoryFile).subscribe({
      next: (result) => {
        this.importingDirectory = false;
        this.lastImportResult = result;
        this.selectedDirectoryFile = null;
        this.loadEmployeeDirectoryStats();
        if (this.hasSearchKeyword) {
          this.refreshSearch();
        }
        this.toast.success('Directory imported', `${result.processedRows} employee rows were processed successfully.`);
      },
      error: (error: any) => {
        this.importingDirectory = false;
        const message = error?.error?.message || error?.message || 'Unable to import the employee directory workbook.';
        this.toast.error('Import failed', message);
      }
    });
  }

  sendResetSms(): void {
    if (!this.selectedUser) {
      this.toast.info('Select a user', 'Choose an employee first.');
      return;
    }

    this.resetForm.markAllAsTouched();
    if (this.resetForm.invalid) {
      return;
    }

    this.sendingReset = true;
    const raw = this.resetForm.getRawValue();
    this.passwordManagement.sendPasswordResetSms({
      externalUserId: this.selectedUser.id,
      systemName: raw.systemName || '',
      password: raw.password || ''
    }).subscribe({
      next: (result) => {
        this.sendingReset = false;
        this.lastDispatch = result;
        this.toast.success('SMS sent', `Password reset SMS for ${result.systemName} was sent to ${this.selectedUser?.fullEmployeeName}.`);
        this.resetForm.reset({ systemName: '', password: '' });
      },
      error: (error: any) => {
        this.sendingReset = false;
        const message = error?.error?.message || error?.message || 'Unable to send password reset SMS.';
        this.toast.error('Send failed', message);
      }
    });
  }

  sendNewUserSms(): void {
    if (!this.selectedUser) {
      this.toast.info('Select a user', 'Choose an employee first.');
      return;
    }

    this.newUserForm.markAllAsTouched();
    if (this.newUserForm.invalid) {
      return;
    }

    const raw = this.newUserForm.getRawValue();
    this.sendingNewUser = true;
    this.passwordManagement.sendNewUserSms({
      externalUserId: this.selectedUser.id,
      systemName: raw.systemName || '',
      username: raw.username || '',
      password: raw.password || ''
    }).subscribe({
      next: (result) => {
        this.sendingNewUser = false;
        this.lastDispatch = result;
        this.toast.success('SMS sent', `New ${result.systemName} credentials were sent to ${this.selectedUser?.fullEmployeeName}.`);
        this.newUserForm.reset({ systemName: '', username: '', password: '' });
      },
      error: (error: any) => {
        this.sendingNewUser = false;
        const message = error?.error?.message || error?.message || 'Unable to send new user credentials.';
        this.toast.error('Send failed', message);
      }
    });
  }

  private formatSelectedUserLabel(user: ExternalDirectoryUser): string {
    const identity = [user.fullEmployeeName, user.employeeId].filter(Boolean).join(' | ');
    return identity.trim();
  }
}
