import { CommonModule } from '@angular/common';
import { ChangeDetectionStrategy, Component } from '@angular/core';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { finalize } from 'rxjs';

import { ContactService } from '../services/contact.service';

@Component({
  selector: 'app-contact-page',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule],
  templateUrl: './contact-page.component.html',
  styleUrls: ['./contact-page.component.scss', './shared-page.scss'],
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class ContactPageComponent {
  readonly form = this.formBuilder.group({
    name: ['', [Validators.required, Validators.minLength(2)]],
    email: ['', [Validators.required, Validators.email]],
    company: ['', [Validators.required, Validators.minLength(2)]],
    projectType: ['', Validators.required],
    budget: ['', Validators.required],
    details: ['', [Validators.required, Validators.minLength(30)]]
  });

  isSubmitting = false;
  successMessage = '';
  errorMessage = '';

  constructor(
    private readonly formBuilder: FormBuilder,
    private readonly contactService: ContactService
  ) {}

  getControlError(controlName: keyof typeof this.form.controls): string {
    const control = this.form.controls[controlName];

    if (!control.touched || !control.errors) {
      return '';
    }

    if (control.errors['required']) {
      return 'This field is required.';
    }

    if (control.errors['email']) {
      return 'Enter a valid email address.';
    }

    if (control.errors['minlength']) {
      return `Please enter at least ${control.errors['minlength'].requiredLength} characters.`;
    }

    return 'Please check this field.';
  }

  submit(): void {
    if (this.form.invalid || this.isSubmitting) {
      this.form.markAllAsTouched();
      return;
    }

    this.isSubmitting = true;
    this.successMessage = '';
    this.errorMessage = '';

    this.contactService
      .submitInquiry(this.form.getRawValue() as any)
      .pipe(finalize(() => (this.isSubmitting = false)))
      .subscribe({
        next: (response: any) => {
          if (response?.fallback) {
            this.errorMessage = 'Direct sending is ready, but EmailJS credentials are still missing. Add the EmailJS service ID, template ID, and public key to enable real email delivery from the site.';
            return;
          }

          this.successMessage = 'Thanks. Your message has been sent and I will reply shortly.';
          this.form.reset();
        },
        error: (error: Error | { error?: { message?: string } }) => {
          this.errorMessage = (error as any)?.error?.message || (error as any)?.message || 'Something went wrong while sending your message. Please try again.';
        }
      });
  }
}
