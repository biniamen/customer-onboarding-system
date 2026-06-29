import { Component } from '@angular/core';
import { FormBuilder, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { AuthService } from 'src/app/services/auth.service';
import { ToastService } from 'src/app/services/toast.service';

@Component({
  selector: 'app-change-password',
  templateUrl: './change-password.component.html',
  styleUrls: ['./change-password.component.css']
})
export class ChangePasswordComponent {
  submitting = false;
  pageError: string | null = null;

  form = this.fb.group({
    currentPassword: ['', [Validators.required]],
    newPassword: ['', [Validators.required, Validators.minLength(8)]],
    confirmPassword: ['', [Validators.required, Validators.minLength(8)]]
  });

  constructor(
    private fb: FormBuilder,
    private auth: AuthService,
    private toast: ToastService,
    private router: Router
  ) {}

  submit(): void {
    this.pageError = null;
    this.form.markAllAsTouched();
    if (this.form.invalid) {
      return;
    }

    const { currentPassword, newPassword, confirmPassword } = this.form.getRawValue();
    if ((newPassword || '') !== (confirmPassword || '')) {
      this.pageError = 'Password confirmation does not match.';
      this.toast.error('Password mismatch', this.pageError);
      return;
    }

    this.submitting = true;
    this.auth.changePassword({
      currentPassword: currentPassword || '',
      newPassword: newPassword || ''
    }).subscribe({
      next: () => {
        this.submitting = false;
        this.toast.success('Password updated', 'Your password was changed successfully.');
        this.router.navigate(['/workspace']);
      },
      error: (error: any) => {
        this.submitting = false;
        this.pageError = error?.error?.message || error?.message || 'Unable to change password.';
        this.toast.error('Password change failed', this.pageError || 'Password change failed.');
      }
    });
  }
}
