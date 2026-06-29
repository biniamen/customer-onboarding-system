import { Component, OnInit } from '@angular/core';
import { FormBuilder, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { AdditionalCustomerDetails, CustomerProfileSnapshot } from 'src/app/models/onboarding.models';
import { CustomerOnboardingService } from 'src/app/services/customer-onboarding.service';

@Component({
  selector: 'app-customer-details',
  templateUrl: './customer-details.component.html',
  styleUrls: ['./customer-details.component.css']
})
export class CustomerDetailsComponent implements OnInit {
  profile: CustomerProfileSnapshot | null = null;

  form = this.fb.group({
    motherName: ['', [Validators.required, Validators.maxLength(120)]],
    occupation: ['', [Validators.required, Validators.maxLength(120)]],
    monthlyIncome: [null as number | null, [Validators.required, Validators.min(1)]],
    dmsReferenceNumber: ['', [Validators.required, Validators.maxLength(80)]],
    employer: ['', [Validators.required, Validators.maxLength(120)]],
    workPosition: ['', [Validators.required, Validators.maxLength(120)]],
    title: ['Ato', [Validators.required]],
    maritalStatus: ['S', [Validators.required]],
    staffStatus: ['NON_STAFF', [Validators.required]],
    accountOpeningAmount: [800, [Validators.required, Validators.min(1)]],
    guardianName: ['']
  });

  constructor(
    private fb: FormBuilder,
    private onboarding: CustomerOnboardingService,
    private router: Router
  ) {}

  ngOnInit(): void {
    this.profile = this.onboarding.getProfileSnapshot();
    if (!this.profile) {
      this.router.navigate(['/fan-verification']);
      return;
    }

    const savedDetails = this.onboarding.getAdditionalDetails();
    if (savedDetails) {
      this.form.patchValue(savedDetails);
    }

    if (this.profile.minor) {
      this.form.controls.guardianName.addValidators([Validators.required, Validators.maxLength(120)]);
      this.form.controls.guardianName.updateValueAndValidity({ emitEvent: false });
    }
  }

  get annualIncome(): number {
    return Number(this.form.controls.monthlyIncome.value || 0) * 12;
  }

  goBack(): void {
    this.router.navigate(['/fan-verification']);
  }

  continue(): void {
    this.form.markAllAsTouched();
    if (this.form.invalid) {
      return;
    }

    this.onboarding.saveAdditionalDetails(this.form.getRawValue() as AdditionalCustomerDetails);
    this.router.navigate(['/review-submit']);
  }
}
