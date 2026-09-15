import { Component, OnInit } from '@angular/core';
import { FormBuilder, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { CustomerSessionService } from 'src/app/services/customer-session.service';
import { IdaService } from 'src/app/services/ida.service';

@Component({
  selector: 'app-fan-verification',
  templateUrl: './fan-verification.component.html',
  styleUrls: ['./fan-verification.component.css']
})
export class FanVerificationComponent implements OnInit {
  sending = false;
  verifying = false;
  showOtpSection = false;
  txnId = '';
  maskedMobile = '';
  maskedEmail = '';
  apiError: string | null = null;
  apiSuccess: string | null = null;
  fanLocked = false;

  form = this.fb.group({
    fan: ['', [Validators.required, Validators.pattern(/^\d{16}$/)]],
    otp: ['', [Validators.pattern(/^\d{6}$/)]]
  });

  constructor(
    private fb: FormBuilder,
    private ida: IdaService,
    private session: CustomerSessionService,
    private router: Router
  ) {}

  ngOnInit(): void {
    const savedFan = this.session.getFan();
    if (savedFan) {
      this.form.patchValue({ fan: savedFan });
    }

    this.txnId = this.session.getFanTxnId();
    this.maskedMobile = this.session.getFanMaskedMobile();
    this.maskedEmail = this.session.getFanMaskedEmail();

    if (this.txnId) {
      this.showOtpSection = true;
      this.fanLocked = true;
      this.f.fan.disable({ emitEvent: false });
    }
  }

  get f() {
    return this.form.controls;
  }

  onFanInput(event: Event): void {
    if (this.fanLocked) {
      return;
    }

    const element = event.target as HTMLInputElement;
    const cleaned = (element.value || '').replace(/\D/g, '').slice(0, 16);
    if (element.value !== cleaned) {
      element.value = cleaned;
    }

    this.f.fan.setValue(cleaned);
  }

  onOtpInput(event: Event): void {
    const element = event.target as HTMLInputElement;
    const cleaned = (element.value || '').replace(/\D/g, '').slice(0, 6);
    if (element.value !== cleaned) {
      element.value = cleaned;
    }

    this.f.otp.setValue(cleaned);
  }

  sendFanOtp(): void {
    this.apiError = null;
    this.apiSuccess = null;
    this.f.fan.markAsTouched();

    if (this.f.fan.invalid) {
      this.apiError = 'Enter a valid 16-digit FAN number before requesting OTP.';
      return;
    }

    const fan = (this.f.fan.value || '').toString().trim();
    this.session.setFan(fan);
    this.sending = true;

    this.ida.sendFanOtp(fan).subscribe({
      next: (response) => {
        this.sending = false;

        const txn = (response?.transactionID || response?.transactionId || '').toString().trim();
        const maskedMobile = response?.response?.maskedMobile || '';
        const maskedEmail = response?.response?.maskedEmail || '';

        if (!txn) {
          this.apiError = 'OTP request succeeded, but the transaction ID was not returned by the IDA service.';
          return;
        }

        this.txnId = txn;
        this.maskedMobile = maskedMobile;
        this.maskedEmail = maskedEmail;
        this.session.setFanOtpMeta(this.txnId, this.maskedMobile, this.maskedEmail);

        this.showOtpSection = true;
        this.fanLocked = true;
        this.f.fan.disable({ emitEvent: false });
        this.f.otp.reset('');
        this.apiSuccess = `OTP sent to ${this.maskedMobile || 'the registered phone'}${this.maskedEmail ? ` and ${this.maskedEmail}` : ''}.`;
      },
      error: (error: any) => {
        this.sending = false;
        this.apiError = error?.message || 'Failed to send FAN OTP.';
      }
    });
  }

  verifyFanOtp(): void {
    this.apiError = null;
    this.apiSuccess = null;

    const fan = (this.form.getRawValue().fan || '').toString().trim();
    const otp = (this.f.otp.value || '').toString().trim();

    this.form.markAllAsTouched();

    if (!/^\d{16}$/.test(fan)) {
      this.apiError = 'Please enter a valid 16-digit FAN number.';
      return;
    }

    if (!this.txnId) {
      this.apiError = 'Transaction ID is missing. Please send OTP again.';
      return;
    }

    if (!/^\d{6}$/.test(otp)) {
      this.apiError = 'Please enter the 6-digit OTP.';
      this.f.otp.setErrors({ pattern: true });
      return;
    }

    this.verifying = true;

    this.ida.verifyFanOtp(fan, otp, this.txnId).subscribe({
      next: (response: any) => {
        this.verifying = false;

        const errors = response?.errors;
        if (Array.isArray(errors) && errors.length > 0) {
          const message = errors[0]?.errorMessage || 'OTP validation failed.';
          const actionMessage = errors[0]?.actionMessage || '';
          this.apiError = actionMessage ? `${message}. ${actionMessage}` : message;
          this.f.otp.reset('');
          return;
        }

        const root = response?.response ? response.response : response;
        const kycStatus = root?.kycStatus === true || root?.kycStatus === 'true';
        const psut = (root?.psut || response?.psut || '').toString().trim();
        const identity = root?.identity || response?.identity;

        if (!kycStatus) {
          this.apiError = 'FAN verification did not pass eKYC validation.';
          return;
        }

        if (!psut) {
          this.apiError = 'NationalIdSubstitute (psut) is missing from the eKYC response.';
          return;
        }

        if (!identity) {
          this.apiError = 'Identity details were not returned from the eKYC response.';
          return;
        }

        this.session.setNidEkycRoot({
          kycStatus: true,
          psut,
          identity
        });

        this.session.setNidIdentity(identity);
        this.apiSuccess = 'Verification successful. Moving to customer profile details.';
        this.router.navigate(['/customer-details']);
      },
      error: (error: any) => {
        this.verifying = false;
        this.apiError = error?.error?.message || error?.message || 'Failed to verify FAN OTP.';
      }
    });
  }

  resend(): void {
    this.sendFanOtp();
  }

  editFan(): void {
    this.apiError = null;
    this.apiSuccess = null;
    this.showOtpSection = false;
    this.txnId = '';
    this.maskedMobile = '';
    this.maskedEmail = '';
    this.fanLocked = false;
    this.session.setFanOtpMeta('', '', '');
    this.session.clearNidEkycRoot();
    this.form.reset({ fan: this.session.getFan() || '', otp: '' });
    this.f.fan.enable({ emitEvent: false });
  }
}
