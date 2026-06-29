import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { AdditionalCustomerDetails, CustomerProfileSnapshot, FcubsSubmissionResult } from 'src/app/models/onboarding.models';
import { CustomerOnboardingService } from 'src/app/services/customer-onboarding.service';
import { CustomerSessionService } from 'src/app/services/customer-session.service';

@Component({
  selector: 'app-review-submit',
  templateUrl: './review-submit.component.html',
  styleUrls: ['./review-submit.component.css']
})
export class ReviewSubmitComponent implements OnInit {
  profile: CustomerProfileSnapshot | null = null;
  details: AdditionalCustomerDetails | null = null;
  result: FcubsSubmissionResult | null = null;
  submitting = false;
  submissionError: string | null = null;

  constructor(
    private onboarding: CustomerOnboardingService,
    private session: CustomerSessionService,
    private router: Router
  ) {}

  ngOnInit(): void {
    this.profile = this.onboarding.getProfileSnapshot();
    this.details = this.onboarding.getAdditionalDetails();
    this.result = this.session.getFcubsResponse<FcubsSubmissionResult>();

    if (!this.profile) {
      this.router.navigate(['/fan-verification']);
      return;
    }

    if (!this.details) {
      this.router.navigate(['/customer-details']);
    }
  }

  back(): void {
    this.router.navigate(['/customer-details']);
  }

  submit(): void {
    this.submitting = true;
    this.submissionError = null;

    this.onboarding.createCustomer().subscribe({
      next: (response) => {
        this.submitting = false;
        this.result = response;
      },
      error: (error: any) => {
        this.submitting = false;
        this.submissionError = error?.message || 'Failed to submit customer creation request to FCUBS.';
      }
    });
  }

  startNew(): void {
    this.session.clearAll();
    this.router.navigate(['/fan-verification']);
  }
}
