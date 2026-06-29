import { Component, OnInit } from '@angular/core';
import { FormBuilder, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { AdditionalCustomerDetails, CustomerProfileSnapshot } from 'src/app/models/onboarding.models';
import { CustomerOnboardingService } from 'src/app/services/customer-onboarding.service';
import { ToastService } from 'src/app/services/toast.service';
import { VerifiedProfileExportService } from 'src/app/services/verified-profile-export.service';

@Component({
  selector: 'app-customer-details',
  templateUrl: './customer-details.component.html',
  styleUrls: ['./customer-details.component.css']
})
export class CustomerDetailsComponent implements OnInit {
  profile: CustomerProfileSnapshot | null = null;
  nidPhotoPreview = '';
  exportingProfile = false;
  readonly internalReferencePrefix = 'DOC';

  form = this.fb.group({
    motherName: ['', [Validators.required, Validators.maxLength(120)]],
    occupation: ['', [Validators.required, Validators.maxLength(120)]],
    monthlyIncome: [null as number | null, [Validators.required, Validators.min(1)]],
    dmsReferenceNumber: ['', [Validators.maxLength(80)]],
    employer: ['', [Validators.required, Validators.maxLength(120)]],
    workPosition: ['', [Validators.required, Validators.maxLength(120)]],
    title: ['Ato', [Validators.required]],
    maritalStatus: ['S', [Validators.required]],
    staffStatus: ['NON_STAFF', [Validators.required]],
    mobileNumber: ['', [Validators.required, Validators.pattern(/^(?:\+?251|0)?9\d{8}$/)]],
    email: ['', [Validators.email, Validators.maxLength(160)]],
    placeOfBirth: ['', [Validators.required, Validators.maxLength(120)]],
    idType: ['FAYDA / NATIONAL ID', [Validators.required, Validators.maxLength(80)]],
    residentIdNumber: ['', [Validators.maxLength(80)]],
    tinNumber: ['', [Validators.maxLength(80)]],
    guardianName: ['', [Validators.maxLength(120)]]
  });

  constructor(
    private fb: FormBuilder,
    private onboarding: CustomerOnboardingService,
    private exportService: VerifiedProfileExportService,
    private router: Router,
    private toast: ToastService
  ) {}

  ngOnInit(): void {
    this.profile = this.onboarding.getProfileSnapshot();
    if (!this.profile) {
      this.router.navigate(['/fan-verification']);
      return;
    }

    void this.loadNidPhotoPreview();
    this.form.patchValue({
      mobileNumber: this.profile.mobileNumber || '',
      email: this.profile.email || '',
      placeOfBirth: this.profile.placeOfBirth || '',
      idType: 'FAYDA / NATIONAL ID'
    });

    const savedDetails = this.onboarding.getAdditionalDetails();
    if (savedDetails) {
      this.form.patchValue(savedDetails);
    }

    if (!savedDetails?.dmsReferenceNumber) {
      this.form.patchValue({
        dmsReferenceNumber: this.generateInternalDocumentReference()
      }, { emitEvent: false });
    }

    this.applyMinorRules();
  }

  get annualIncome(): number | null {
    const monthlyIncome = this.form.controls.monthlyIncome.value;
    return monthlyIncome && monthlyIncome > 0 ? Number(monthlyIncome) * 12 : null;
  }

  goBack(): void {
    this.router.navigate(['/fan-verification']);
  }

  async downloadVerifiedProfile(): Promise<void> {
    if (!this.profile) {
      return;
    }

    this.exportingProfile = true;
    try {
      await this.exportService.downloadProfile(this.profile, this.form.getRawValue() as AdditionalCustomerDetails);
      this.toast.success('Verified profile ready', 'The customer identity profile was downloaded successfully.');
    } finally {
      this.exportingProfile = false;
    }
  }

  continue(): void {
    this.form.markAllAsTouched();
    if (this.form.invalid) {
      this.toast.error('Missing required details', 'Complete the mandatory KYC fields before continuing.');
      return;
    }

    const rawDetails = this.form.getRawValue();
    const normalizedDetails: AdditionalCustomerDetails = {
      ...(rawDetails as AdditionalCustomerDetails),
      monthlyIncome: rawDetails.monthlyIncome ? Number(rawDetails.monthlyIncome) : null,
      dmsReferenceNumber: (rawDetails.dmsReferenceNumber || this.generateInternalDocumentReference()).trim()
    };

    this.onboarding.saveAdditionalDetails(normalizedDetails);
    this.router.navigate(['/review-submit']);
  }

  private async loadNidPhotoPreview(): Promise<void> {
    this.nidPhotoPreview = await this.onboarding.resolveIdentityPhotoPreview(this.profile?.photoBase64);
  }

  private applyMinorRules(): void {
    const monthlyIncomeControl = this.form.controls.monthlyIncome;
    const guardianNameControl = this.form.controls.guardianName;

    if (this.profile?.minor) {
      monthlyIncomeControl.setValidators([Validators.min(1)]);
      guardianNameControl.setValidators([Validators.required, Validators.maxLength(120)]);

      if (monthlyIncomeControl.value === 0) {
        monthlyIncomeControl.setValue(null, { emitEvent: false });
      }
    } else {
      monthlyIncomeControl.setValidators([Validators.required, Validators.min(1)]);
      guardianNameControl.setValidators([Validators.maxLength(120)]);
    }

    monthlyIncomeControl.updateValueAndValidity({ emitEvent: false });
    guardianNameControl.updateValueAndValidity({ emitEvent: false });
  }

  private generateInternalDocumentReference(): string {
    const timestamp = new Date().toISOString().replace(/[-:.TZ]/g, '').slice(0, 14);
    const suffix = Math.floor(1000 + Math.random() * 9000);
    return `${this.internalReferencePrefix}-${timestamp}-${suffix}`;
  }
}
