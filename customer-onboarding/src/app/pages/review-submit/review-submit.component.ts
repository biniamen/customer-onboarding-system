import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { AdditionalCustomerDetails, CustomerProfileSnapshot, FcubsSubmissionResult } from 'src/app/models/onboarding.models';
import { CustomerOnboardingService } from 'src/app/services/customer-onboarding.service';
import { CustomerSessionService } from 'src/app/services/customer-session.service';
import { ToastService } from 'src/app/services/toast.service';
import { VerifiedProfileExportService } from 'src/app/services/verified-profile-export.service';

@Component({
  selector: 'app-review-submit',
  templateUrl: './review-submit.component.html',
  styleUrls: ['./review-submit.component.css']
})
export class ReviewSubmitComponent implements OnInit {
  profile: CustomerProfileSnapshot | null = null;
  details: AdditionalCustomerDetails | null = null;
  result: FcubsSubmissionResult | null = null;
  nidPhotoPreview = '';
  submitting = false;
  downloading = false;
  submissionError: string | null = null;

  constructor(
    private onboarding: CustomerOnboardingService,
    private session: CustomerSessionService,
    private exportService: VerifiedProfileExportService,
    private router: Router,
    private toast: ToastService
  ) {}

  ngOnInit(): void {
    this.profile = this.onboarding.getProfileSnapshot();
    this.details = this.onboarding.getAdditionalDetails();
    this.result = this.session.getFcubsResponse<FcubsSubmissionResult>();

    if (!this.profile) {
      this.router.navigate(['/fan-verification']);
      return;
    }

    void this.loadNidPhotoPreview();

    if (!this.details) {
      this.router.navigate(['/customer-details']);
    }
  }

  back(): void {
    this.router.navigate(['/customer-details']);
  }

  async downloadVerifiedProfile(): Promise<void> {
    if (!this.profile) {
      return;
    }

    this.downloading = true;
    try {
      await this.exportService.downloadProfile(this.profile, this.details);
      this.toast.success('Verified profile ready', 'The customer verification profile was downloaded successfully.');
    } finally {
      this.downloading = false;
    }
  }

  submit(): void {
    this.submitting = true;
    this.submissionError = null;

    this.onboarding.createCustomer().subscribe({
      next: (response) => {
        this.submitting = false;
        this.result = response;
        if (response.success && response.customerNumber) {
          this.router.navigate(['/account-creation']);
        }
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

  private async loadNidPhotoPreview(): Promise<void> {
    this.nidPhotoPreview = await this.onboarding.resolveIdentityPhotoPreview(this.profile?.photoBase64);
  }
}
