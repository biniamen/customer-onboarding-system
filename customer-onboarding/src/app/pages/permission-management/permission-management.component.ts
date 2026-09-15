import { Component, OnInit } from '@angular/core';
import { FormBuilder, Validators } from '@angular/forms';
import {
  RolePermissionAssignment,
  SystemPermission,
  UserRole
} from 'src/app/models/onboarding.models';
import { PermissionManagementService } from 'src/app/services/permission-management.service';
import { ToastService } from 'src/app/services/toast.service';

@Component({
  selector: 'app-permission-management',
  templateUrl: './permission-management.component.html',
  styleUrls: ['./permission-management.component.css']
})
export class PermissionManagementComponent implements OnInit {
  readonly roles: UserRole[] = [
    'ADMIN',
    'SYSTEM_ADMIN',
    'SENIOR_MANAGEMENT',
    'BRANCH_BANKING',
    'HR',
    'MAKER',
    'CHECKER',
    'RENTAL_MAKER',
    'RENTAL_CHECKER',
    'REPORT_VIEWER',
    'KYC_UNIT'
  ];

  permissions: SystemPermission[] = [];
  roleAssignments: RolePermissionAssignment[] = [];
  selectedRole: UserRole = 'MAKER';
  selectedPermission: SystemPermission | null = null;
  selectedCodes: string[] = [];
  loading = false;
  savingPermission = false;
  savingAssignments = false;
  deleting = false;
  pageError = '';
  editorOpen = false;

  form = this.fb.group({
    code: ['', [Validators.required, Validators.pattern(/^[A-Z][A-Z0-9_]{2,63}$/)]],
    name: ['', [Validators.required, Validators.minLength(3), Validators.maxLength(160)]],
    description: ['', [Validators.maxLength(500)]],
    isActive: [true]
  });

  constructor(
    private fb: FormBuilder,
    private permissionsService: PermissionManagementService,
    private toast: ToastService
  ) {}

  ngOnInit(): void {
    this.loadConfiguration();
  }

  get selectedRoleLabel(): string {
    return this.formatRole(this.selectedRole);
  }

  get activePermissionCount(): number {
    return this.permissions.filter(permission => permission.isActive).length;
  }

  get assignedCount(): number {
    return this.selectedCodes.length;
  }

  isAssigned(permission: SystemPermission): boolean {
    return this.selectedCodes.includes(permission.code);
  }

  formatRole(role: string): string {
    return (role || '').replace(/_/g, ' ');
  }

  formatRoles(roles: string[]): string {
    return roles.length ? roles.map(role => this.formatRole(role)).join(', ') : 'Not assigned';
  }

  loadConfiguration(): void {
    this.loading = true;
    this.pageError = '';
    this.permissionsService.getConfiguration().subscribe({
      next: response => {
        this.loading = false;
        this.permissions = [...(response.permissions || [])].sort((left, right) => left.name.localeCompare(right.name));
        this.roleAssignments = response.roleAssignments || [];
        this.syncSelectedRole();
      },
      error: error => {
        this.loading = false;
        this.pageError = this.readError(error, 'Unable to load permission configuration.');
        this.toast.error('Permission configuration unavailable', this.pageError);
      }
    });
  }

  selectRole(role: UserRole): void {
    this.selectedRole = role;
    this.syncSelectedRole();
  }

  toggleAssignment(permission: SystemPermission, checked: boolean): void {
    if (!permission.isActive) {
      return;
    }

    this.selectedCodes = checked
      ? [...new Set([...this.selectedCodes, permission.code])]
      : this.selectedCodes.filter(code => code !== permission.code);
  }

  openCreate(): void {
    this.selectedPermission = null;
    this.form.enable({ emitEvent: false });
    this.form.reset({ code: '', name: '', description: '', isActive: true });
    this.editorOpen = true;
  }

  openEdit(permission: SystemPermission): void {
    this.selectedPermission = permission;
    this.form.reset({
      code: permission.code,
      name: permission.name,
      description: permission.description || '',
      isActive: permission.isActive
    });
    this.form.controls.code.disable({ emitEvent: false });
    this.editorOpen = true;
  }

  closeEditor(): void {
    if (this.savingPermission || this.deleting) {
      return;
    }
    this.editorOpen = false;
    this.selectedPermission = null;
  }

  savePermission(): void {
    this.form.markAllAsTouched();
    if (this.form.invalid) {
      this.toast.error('Complete required fields', 'Use an uppercase permission code and enter a clear permission name.');
      return;
    }

    const values = this.form.getRawValue();
    this.savingPermission = true;
    this.pageError = '';
    const payload = {
      name: (values.name || '').trim(),
      description: (values.description || '').trim() || null,
      isActive: !!values.isActive
    };

    const request = this.selectedPermission
      ? this.permissionsService.updatePermission(this.selectedPermission.id, payload)
      : this.permissionsService.createPermission({
          ...payload,
          code: (values.code || '').trim().toUpperCase()
        });

    request.subscribe({
      next: permission => {
        this.savingPermission = false;
        this.permissions = this.selectedPermission
          ? this.permissions.map(item => item.id === permission.id ? permission : item)
          : [...this.permissions, permission];
        this.permissions.sort((left, right) => left.name.localeCompare(right.name));
        this.syncSelectedRole();
        this.toast.success(this.selectedPermission ? 'Permission updated' : 'Permission created', `${permission.name} is ready for role assignment.`);
        this.closeEditor();
      },
      error: error => {
        this.savingPermission = false;
        this.pageError = this.readError(error, 'Unable to save this permission.');
        this.toast.error('Permission save failed', this.pageError);
      }
    });
  }

  deletePermission(): void {
    if (!this.selectedPermission || !window.confirm(`Delete ${this.selectedPermission.code}? Remove it from every role first.`)) {
      return;
    }

    this.deleting = true;
    this.permissionsService.deletePermission(this.selectedPermission.id).subscribe({
      next: () => {
        const deletedCode = this.selectedPermission?.code;
        this.deleting = false;
        this.permissions = this.permissions.filter(permission => permission.code !== deletedCode);
        this.roleAssignments = this.roleAssignments.map(assignment => ({
          ...assignment,
          permissionCodes: assignment.permissionCodes.filter(code => code !== deletedCode)
        }));
        this.syncSelectedRole();
        this.toast.success('Permission deleted', 'The permission is no longer available for assignment.');
        this.closeEditor();
      },
      error: error => {
        this.deleting = false;
        this.pageError = this.readError(error, 'Unable to delete this permission.');
        this.toast.error('Permission deletion blocked', this.pageError);
      }
    });
  }

  saveAssignments(): void {
    this.savingAssignments = true;
    this.pageError = '';
    this.permissionsService.updateRoleAssignments(this.selectedRole, { permissionCodes: this.selectedCodes }).subscribe({
      next: assignment => {
        this.savingAssignments = false;
        this.roleAssignments = [
          ...this.roleAssignments.filter(item => item.role !== assignment.role),
          assignment
        ];
        this.permissions = this.permissions.map(permission => ({
          ...permission,
          assignedRoles: assignment.permissionCodes.includes(permission.code)
            ? [...new Set([...permission.assignedRoles.filter(role => role !== assignment.role), assignment.role])]
            : permission.assignedRoles.filter(role => role !== assignment.role)
        }));
        this.syncSelectedRole();
        this.toast.success('Role permissions saved', `${this.selectedRoleLabel} now has ${assignment.permissionCodes.length} assigned permission${assignment.permissionCodes.length === 1 ? '' : 's'}.`);
      },
      error: error => {
        this.savingAssignments = false;
        this.pageError = this.readError(error, 'Unable to update role permissions.');
        this.toast.error('Role assignment save failed', this.pageError);
      }
    });
  }

  private syncSelectedRole(): void {
    const assignment = this.roleAssignments.find(item => item.role === this.selectedRole);
    this.selectedCodes = (assignment?.permissionCodes || [])
      .filter(code => this.permissions.some(permission => permission.code === code && permission.isActive));
  }

  private readError(error: any, fallback: string): string {
    return error?.error?.message || error?.message || fallback;
  }
}
