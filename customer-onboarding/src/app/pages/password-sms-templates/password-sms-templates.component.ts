import { Component, OnInit } from '@angular/core';
import { FormBuilder, Validators } from '@angular/forms';
import { PasswordMessageTemplate } from 'src/app/models/onboarding.models';
import { PasswordManagementService } from 'src/app/services/password-management.service';
import { ToastService } from 'src/app/services/toast.service';

@Component({
  selector: 'app-password-sms-templates',
  templateUrl: './password-sms-templates.component.html',
  styleUrls: ['./password-sms-templates.component.css']
})
export class PasswordSmsTemplatesComponent implements OnInit {
  loading = false;
  savingReset = false;
  savingNewUser = false;
  pageError: string | null = null;

  resetTemplate: PasswordMessageTemplate | null = null;
  newUserTemplate: PasswordMessageTemplate | null = null;

  resetTemplateForm = this.fb.group({
    title: ['', [Validators.required]],
    body: ['', [Validators.required]],
    isActive: [true]
  });

  newUserTemplateForm = this.fb.group({
    title: ['', [Validators.required]],
    body: ['', [Validators.required]],
    isActive: [true]
  });

  constructor(
    private fb: FormBuilder,
    private passwordManagement: PasswordManagementService,
    private toast: ToastService
  ) {}

  ngOnInit(): void {
    this.loadTemplates();
  }

  loadTemplates(): void {
    this.loading = true;
    this.pageError = null;

    this.passwordManagement.getTemplates().subscribe({
      next: (templates) => {
        this.loading = false;
        this.resetTemplate = templates.find((template) => template.templateType === 'PASSWORD_RESET') || null;
        this.newUserTemplate = templates.find((template) => template.templateType === 'NEW_USER_CREATION') || null;

        this.resetTemplateForm.patchValue({
          title: this.resetTemplate?.title || 'Password reset SMS',
          body: this.resetTemplate?.body || '',
          isActive: this.resetTemplate?.isActive ?? true
        });

        this.newUserTemplateForm.patchValue({
          title: this.newUserTemplate?.title || 'New user credential SMS',
          body: this.newUserTemplate?.body || '',
          isActive: this.newUserTemplate?.isActive ?? true
        });
      },
      error: (error: any) => {
        this.loading = false;
        this.pageError = error?.error?.message || error?.message || 'Unable to load password SMS templates.';
        this.toast.error('Load failed', this.pageError || 'Load failed.');
      }
    });
  }

  saveResetTemplate(): void {
    this.resetTemplateForm.markAllAsTouched();
    if (this.resetTemplateForm.invalid) {
      return;
    }

    this.savingReset = true;
    this.passwordManagement.saveTemplate('PASSWORD_RESET', this.resetTemplateForm.getRawValue() as any).subscribe({
      next: (template) => {
        this.savingReset = false;
        this.resetTemplate = template;
        this.toast.success('Template saved', 'Password reset SMS template was updated.');
      },
      error: (error: any) => {
        this.savingReset = false;
        const message = error?.error?.message || error?.message || 'Unable to save the reset template.';
        this.toast.error('Save failed', message);
      }
    });
  }

  saveNewUserTemplate(): void {
    this.newUserTemplateForm.markAllAsTouched();
    if (this.newUserTemplateForm.invalid) {
      return;
    }

    this.savingNewUser = true;
    this.passwordManagement.saveTemplate('NEW_USER_CREATION', this.newUserTemplateForm.getRawValue() as any).subscribe({
      next: (template) => {
        this.savingNewUser = false;
        this.newUserTemplate = template;
        this.toast.success('Template saved', 'New user SMS template was updated.');
      },
      error: (error: any) => {
        this.savingNewUser = false;
        const message = error?.error?.message || error?.message || 'Unable to save the new user template.';
        this.toast.error('Save failed', message);
      }
    });
  }
}
