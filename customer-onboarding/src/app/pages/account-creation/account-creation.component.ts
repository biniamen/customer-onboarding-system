import { Component, OnInit } from '@angular/core';
import { DomSanitizer, SafeResourceUrl } from '@angular/platform-browser';
import { FormBuilder, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { firstValueFrom } from 'rxjs';
import {
  AccountClassOption,
  ApprovalRecord,
  ApprovalSubmissionPayload,
  AdditionalCustomerDetails,
  AccountOpeningDetails,
  CustomerProfileSnapshot,
  FcubsSubmissionResult,
  FundingSourceType,
  SupportingDocument
} from 'src/app/models/onboarding.models';
import { ApprovalWorkflowService } from 'src/app/services/approval-workflow.service';
import { AuthService } from 'src/app/services/auth.service';
import { CustomerOnboardingService } from 'src/app/services/customer-onboarding.service';
import { CustomerSessionService } from 'src/app/services/customer-session.service';
import { ToastService } from 'src/app/services/toast.service';
import { environment } from 'src/environments/environment';

@Component({
  selector: 'app-account-creation',
  templateUrl: './account-creation.component.html',
  styleUrls: ['./account-creation.component.css']
})
export class AccountCreationComponent implements OnInit {
  readonly localDocumentCategories = [
    { category: 'APPLICATION_FORM', displayName: 'Application Form', required: false },
    { category: 'SUPPORTING_KYC', displayName: 'Supporting KYC Document', required: false }
  ];
  readonly optionalDocumentCategories = [
    { category: 'BIRTH_CERTIFICATE', displayName: 'Birth Certificate' },
    { category: 'ADDITIONAL_KYC', displayName: 'Additional KYC Document' },
    { category: 'RESIDENT_CARD', displayName: 'Resident / Yellow Card Copy' },
    { category: 'OTHER', displayName: 'Other Supporting Document' }
  ];
  accountClasses: AccountClassOption[] = [];
  profile: CustomerProfileSnapshot | null = null;
  customerResult: FcubsSubmissionResult | null = null;
  approvalRecord: ApprovalRecord | null = null;
  uploadResponse: any = null;
  uploadSuccessMessage: string | null = null;
  uploadPreviewReady = false;
  approvalReady = false;
  uploading = false;
  submittingApproval = false;
  pageError: string | null = null;
  selectedImagePreview = '';
  selectedSignaturePreview = '';
  nidPhotoPreview = '';
  viewerTitle = '';
  viewerUrl = '';
  viewerMimeType = '';
  viewerResourceUrl: SafeResourceUrl | null = null;
  additionalDetails: AdditionalCustomerDetails | null = null;
  localDocuments: Record<string, SupportingDocument | null> = {
    APPLICATION_FORM: null,
    SUPPORTING_KYC: null
  };
  optionalDocuments: SupportingDocument[] = [];
  loadingAccountClasses = false;
  readonly branchCode: string;

  form = this.fb.group({
    accountClass: ['SPIA', [Validators.required]],
    accountNumberTemplate: ['', [Validators.required, Validators.maxLength(20)]],
    openingAmount: [0, [Validators.required, Validators.min(1)]],
    fundingSourceType: ['CASH' as FundingSourceType, [Validators.required]],
    fundingSourceValue: [''],
    imageBase64: ['', [Validators.required]],
    imageFileName: ['', [Validators.required]],
    imageFileType: ['JPG', [Validators.required]],
    signatureBase64: ['', [Validators.required]],
    signatureFileName: ['', [Validators.required]],
    signatureFileType: ['JPG', [Validators.required]]
  });

  constructor(
    private fb: FormBuilder,
    private workflow: ApprovalWorkflowService,
    private auth: AuthService,
    private onboarding: CustomerOnboardingService,
    private session: CustomerSessionService,
    private router: Router,
    private toast: ToastService,
    private sanitizer: DomSanitizer
  ) {
    this.branchCode = (this.auth.getBranchCode() || '').trim();
  }

  async ngOnInit(): Promise<void> {
    this.profile = this.onboarding.getProfileSnapshot();
    this.customerResult = this.session.getFcubsResponse<FcubsSubmissionResult>();
    this.additionalDetails = this.session.getAdditionalDetails();

    if (!this.profile) {
      this.router.navigate(['/fan-verification']);
      return;
    }

    if (!this.customerResult?.customerNumber) {
      this.router.navigate(['/review-submit']);
      return;
    }

    if (!this.branchCode) {
      this.pageError = 'Logged-in user branch code is missing. Please sign in again before continuing with account creation.';
      this.toast.error('Branch code missing', this.pageError);
      return;
    }

    await this.loadAccountClasses();
    void this.loadNidPhotoPreview();

    const savedDetails = this.onboarding.getAccountOpeningDetails();
    if (savedDetails) {
      this.form.patchValue(savedDetails);
      this.uploadPreviewReady = true;
      this.selectedImagePreview = savedDetails.imageBase64 ? `data:image/${savedDetails.imageFileType.toLowerCase()};base64,${savedDetails.imageBase64}` : '';
      this.selectedSignaturePreview = savedDetails.signatureBase64 ? `data:image/${savedDetails.signatureFileType.toLowerCase()};base64,${savedDetails.signatureBase64}` : '';
      this.applySavedDocuments(savedDetails.uploadedDocuments || []);
    }

    this.form.patchValue({
      fundingSourceType: 'CASH',
      fundingSourceValue: ''
    }, { emitEvent: false });

    this.ensureSelectedAccountClass();
    this.refreshApprovalReadiness();

    this.form.controls.accountClass.valueChanges.subscribe((value) => {
      this.syncAccountClassSelection(value || this.defaultAccountClassCode);
    });
  }

  get customerNumber(): string {
    return this.customerResult?.customerNumber || '';
  }

  get selectedAccountClassName(): string {
    const code = this.form.controls.accountClass.value || '';
    return this.accountClasses.find((item) => item.code === code)?.name || '';
  }

  get selectedAccountClassOption(): AccountClassOption | undefined {
    const code = this.form.controls.accountClass.value || '';
    return this.accountClasses.find((item) => item.code === code);
  }

  get minimumOpeningAmount(): number {
    return Number(this.selectedAccountClassOption?.minimumOpeningBalance || 0);
  }

  get selectedAccountCurrencyCode(): string {
    return this.selectedAccountClassOption?.currencyCode || 'ETB';
  }

  get defaultAccountClassCode(): string {
    return this.accountClasses[0]?.code || environment.bankDefaults.accountClass || 'SPIA';
  }

  get isFundingSourceValueRequired(): boolean {
    return false;
  }

  onImageSelected(event: Event): void {
    this.handleFileSelection(event, 'image');
  }

  onSignatureSelected(event: Event): void {
    this.handleFileSelection(event, 'signature');
  }

  uploadAssets(): void {
    this.pageError = null;
    this.uploadSuccessMessage = null;
    this.form.markAllAsTouched();
    if (this.form.invalid) {
      return;
    }

    const gatingError = this.validateAssetUploadPrerequisites();
    if (gatingError) {
      this.pageError = gatingError;
      this.toast.error('Complete required items', gatingError);
      return;
    }

    const details = this.buildAccountOpeningDetails();
    this.onboarding.saveAccountOpeningDetails(details);
    this.uploading = true;

    this.onboarding.uploadCustomerImageAndSignature(this.customerNumber, details).subscribe({
      next: (response) => {
        this.uploading = false;
        this.uploadResponse = response;
        this.uploadPreviewReady = true;
        this.refreshApprovalReadiness();
        this.uploadSuccessMessage = 'Customer photo and signature are ready for checker review.';
        this.toast.success('Files uploaded', 'Customer photo and signature are ready for checker review.');
      },
      error: (error: any) => {
        this.uploading = false;
        this.pageError = error?.error?.message || error?.message || 'Failed to upload customer image and signature.';
        this.toast.error('Upload failed', this.pageError || 'Upload failed.');
      }
    });
  }

  submitForApproval(): void {
    this.pageError = null;
    this.form.markAllAsTouched();
    if (this.form.invalid || !this.customerNumber) {
      return;
    }

    const gatingError = this.validateApprovalPrerequisites();
    if (gatingError) {
      this.pageError = gatingError;
      this.toast.error('Submission blocked', gatingError);
      return;
    }

    const details = this.buildAccountOpeningDetails();
    this.onboarding.saveAccountOpeningDetails(details);
    this.submittingApproval = true;

    const payload = this.buildApprovalPayload(details);
    this.workflow.submitForApproval(payload).subscribe({
      next: (response) => {
        this.submittingApproval = false;
        this.approvalRecord = response;
        this.toast.success('Submitted', `Case ${response.caseReference} is now waiting for checker approval.`);
        this.session.clearAll();
        this.router.navigate(['/workspace']);
      },
      error: (error: any) => {
        this.submittingApproval = false;
        this.pageError = error?.error?.message || error?.message || 'Failed to submit the case for checker approval.';
        this.toast.error('Submission failed', this.pageError || 'Submission failed.');
      }
    });
  }

  finishProcess(): void {
    this.session.clearAll();
    this.router.navigate(['/workspace']);
  }

  onRequiredDocumentSelected(event: Event, category: string, displayName: string): void {
    const document = this.buildDocumentFromEvent(event, category, displayName, false);
    if (!document) {
      return;
    }

    this.localDocuments[category] = document;
    this.refreshApprovalReadiness();
  }

  onOptionalDocumentSelected(event: Event, category: string, displayName: string): void {
    const document = this.buildDocumentFromEvent(event, category, displayName, false);
    if (!document) {
      return;
    }

    const existingIndex = this.optionalDocuments.findIndex((item) => item.category === category);
    if (existingIndex >= 0) {
      this.optionalDocuments.splice(existingIndex, 1, document);
    } else {
      this.optionalDocuments = [...this.optionalDocuments, document];
    }

    this.refreshApprovalReadiness();
  }

  removeOptionalDocument(category: string): void {
    this.optionalDocuments = this.optionalDocuments.filter((item) => item.category !== category);
    this.refreshApprovalReadiness();
  }

  getOptionalDocument(category: string): SupportingDocument | undefined {
    return this.optionalDocuments.find((item) => item.category === category);
  }

  get allSupportingDocuments(): SupportingDocument[] {
    return [
      ...Object.values(this.localDocuments).filter((item): item is SupportingDocument => !!item),
      ...this.optionalDocuments
    ];
  }

  isViewerOpen(): boolean {
    return !!this.viewerUrl;
  }

  openAssetViewer(title: string, url: string, mimeType = 'image/jpeg'): void {
    if (!url) {
      return;
    }

    this.viewerTitle = title;
    this.viewerUrl = url;
    this.viewerMimeType = mimeType;
    this.viewerResourceUrl = this.sanitizer.bypassSecurityTrustResourceUrl(url);
  }

  closeAssetViewer(): void {
    this.viewerTitle = '';
    this.viewerUrl = '';
    this.viewerMimeType = '';
    this.viewerResourceUrl = null;
  }

  openDocumentViewer(document: SupportingDocument): void {
    const url = this.getDocumentUrl(document);
    this.openAssetViewer(document.displayName || document.fileName, url, document.mimeType || 'application/octet-stream');
  }

  getDocumentUrl(document: SupportingDocument): string {
    return this.onboarding.buildDocumentDownloadUrl(document);
  }

  isImageMimeType(mimeType: string | null | undefined): boolean {
    return this.onboarding.resolveDocumentMimeType(mimeType).startsWith('image/');
  }

  isPdfMimeType(mimeType: string | null | undefined): boolean {
    return this.onboarding.resolveDocumentMimeType(mimeType).includes('pdf');
  }

  private handleFileSelection(event: Event, type: 'image' | 'signature'): void {
    const input = event.target as HTMLInputElement;
    const file = input.files?.[0];
    if (!file) {
      return;
    }

    const reader = new FileReader();
    reader.onload = () => {
      const result = `${reader.result || ''}`;
      const base64 = result.includes(',') ? result.split(',')[1] : result;
      const extension = (file.name.split('.').pop() || 'jpg').toUpperCase();
      const fileType = extension === 'JPEG' ? 'JPG' : extension;

      if (type === 'image') {
        this.form.patchValue({
          imageBase64: base64,
          imageFileName: file.name,
          imageFileType: fileType
        });
        this.selectedImagePreview = result;
      } else {
        this.form.patchValue({
          signatureBase64: base64,
          signatureFileName: file.name,
          signatureFileType: fileType
        });
        this.selectedSignaturePreview = result;
      }

      this.uploadPreviewReady = false;
      this.uploadResponse = null;
      this.uploadSuccessMessage = null;
      this.refreshApprovalReadiness();
    };

    reader.readAsDataURL(file);
  }

  private buildAccountOpeningDetails(): AccountOpeningDetails {
    const raw = this.form.getRawValue();
    const accountClass = raw.accountClass || this.defaultAccountClassCode;
    const accountTemplate = this.buildAccountReferenceTemplate(accountClass);
    return {
      accountClass,
      accountClassName: this.selectedAccountClassName,
      accountCode: this.resolveAccountCode(accountClass),
      accountNumberTemplate: accountTemplate,
      openingAmount: Number(raw.openingAmount || 0),
      fundingSourceType: 'CASH',
      fundingSourceValue: '',
      signatureBase64: raw.signatureBase64 || '',
      signatureFileType: raw.signatureFileType || 'JPG',
      signatureFileName: raw.signatureFileName || '',
      imageBase64: raw.imageBase64 || '',
      imageFileType: raw.imageFileType || 'JPG',
      imageFileName: raw.imageFileName || '',
      uploadedDocuments: [
        ...Object.values(this.localDocuments).filter((item): item is SupportingDocument => !!item),
        ...this.optionalDocuments
      ]
    };
  }

  private buildAccountReferenceTemplate(accountClass: string): string {
    const branchCode = this.branchCode;
    const accountCode = this.resolveAccountCode(accountClass);
    return `${branchCode}${accountCode}CCCCS`.slice(0, 20);
  }

  private resolveAccountCode(accountClass: string): string {
    return this.accountClasses.find((item) => item.code === (accountClass || 'SPIA'))?.accountCode
      || environment.bankDefaults.accountClassCodes?.[accountClass || 'SPIA']
      || environment.bankDefaults.defaultAccountCode
      || '11';
  }

  private buildApprovalPayload(details: AccountOpeningDetails): ApprovalSubmissionPayload {
    const additionalDetails = this.session.getAdditionalDetails();
    if (!this.profile || !this.customerResult || !additionalDetails) {
      throw new Error('Approval payload is incomplete.');
    }

    return {
      fan: this.session.getFan(),
      psut: this.session.getPsut(),
      customerNumber: this.customerNumber,
      customerName: this.profile.fullName,
      branchCode: this.branchCode,
      accountClass: details.accountClass,
      accountClassName: details.accountClassName,
      openingAmount: details.openingAmount,
      fundingSourceType: details.fundingSourceType,
      fundingSourceValue: details.fundingSourceValue,
      accountReference: details.accountNumberTemplate,
      snapshot: this.profile,
      additionalDetails,
      cifResponse: this.customerResult,
      accountDetails: details,
      uploadResponse: this.uploadResponse || { success: true, message: this.uploadSuccessMessage || 'Uploaded successfully.' }
    };
  }

  private refreshApprovalReadiness(): void {
    const hasImage = !!this.form.controls.imageBase64.value;
    const hasSignature = !!this.form.controls.signatureBase64.value;
    this.approvalReady = this.uploadPreviewReady && hasImage && hasSignature;
  }

  private validateApprovalPrerequisites(): string | null {
    if (!this.additionalDetails) {
      return 'Customer details are missing. Please complete the KYC form first.';
    }

    if (!this.additionalDetails.mobileNumber || !this.additionalDetails.placeOfBirth || !this.additionalDetails.idType) {
      return 'Complete the mandatory mobile, place of birth, and ID type fields before submission.';
    }

    const accountClass = (this.form.controls.accountClass.value || '').toUpperCase();
    if (accountClass === 'SSPI' && !this.additionalDetails.tinNumber?.trim()) {
      return 'TIN number is required for Special Saving account requests.';
    }

    const fundingValidationError = this.validateFundingSourceSelection();
    if (fundingValidationError) {
      return fundingValidationError;
    }

    const openingAmountValidationError = this.validateOpeningAmount();
    if (openingAmountValidationError) {
      return openingAmountValidationError;
    }

    if (!this.form.controls.imageBase64.value || !this.form.controls.signatureBase64.value) {
      return 'Customer photo and signature must be uploaded before submission.';
    }

    if (!this.uploadPreviewReady) {
      return 'Upload the customer photo and signature successfully before submission.';
    }

    return null;
  }

  private validateAssetUploadPrerequisites(): string | null {
    if (!this.additionalDetails) {
      return 'Customer details are missing. Please complete the KYC form first.';
    }

    if (!this.additionalDetails.mobileNumber || !this.additionalDetails.placeOfBirth || !this.additionalDetails.idType) {
      return 'Complete the mandatory mobile, place of birth, and ID type fields before uploading.';
    }

    const accountClass = (this.form.controls.accountClass.value || '').toUpperCase();
    if (accountClass === 'SSPI' && !this.additionalDetails.tinNumber?.trim()) {
      return 'TIN number is required for Special Saving account requests.';
    }

    const fundingValidationError = this.validateFundingSourceSelection();
    if (fundingValidationError) {
      return fundingValidationError;
    }

    const openingAmountValidationError = this.validateOpeningAmount();
    if (openingAmountValidationError) {
      return openingAmountValidationError;
    }

    if (!this.form.controls.imageBase64.value || !this.form.controls.signatureBase64.value) {
      return 'Customer photo and signature must be selected before upload.';
    }

    return null;
  }

  private buildDocumentFromEvent(
    event: Event,
    category: string,
    displayName: string,
    required: boolean
  ): SupportingDocument | null {
    const input = event.target as HTMLInputElement;
    const file = input.files?.[0];
    if (!file) {
      return null;
    }

    const reader = new FileReader();
    reader.onload = () => {
      const rawResult = `${reader.result || ''}`;
      const base64 = rawResult.includes(',') ? rawResult.split(',')[1] : rawResult;
      const document: SupportingDocument = {
        id: `${category}-${Date.now()}`,
        category,
        displayName,
        fileName: file.name,
        mimeType: this.onboarding.resolveDocumentMimeType(file.type || '', file.name),
        base64,
        required,
        uploadedAtUtc: new Date().toISOString()
      };

      if (this.localDocuments[category] !== undefined) {
        this.localDocuments[category] = document;
      } else {
        const existingIndex = this.optionalDocuments.findIndex((item) => item.category === category);
        if (existingIndex >= 0) {
          this.optionalDocuments.splice(existingIndex, 1, document);
        } else {
          this.optionalDocuments = [...this.optionalDocuments, document];
        }
      }

      this.refreshApprovalReadiness();
    };

    reader.readAsDataURL(file);
    return null;
  }

  private applySavedDocuments(documents: SupportingDocument[]): void {
    this.localDocuments = {
      APPLICATION_FORM: null,
      SUPPORTING_KYC: null
    };
    this.optionalDocuments = [];

    (documents || []).forEach((document) => {
      if ((document.category === 'APPLICATION_FORM' || document.category === 'SUPPORTING_KYC') && this.localDocuments[document.category] !== undefined) {
        this.localDocuments[document.category] = document;
        return;
      }

      this.optionalDocuments = [...this.optionalDocuments, document];
    });
  }

  private async loadNidPhotoPreview(): Promise<void> {
    this.nidPhotoPreview = await this.onboarding.resolveIdentityPhotoPreview(this.profile?.photoBase64);
  }

  private async loadAccountClasses(): Promise<void> {
    this.loadingAccountClasses = true;
    try {
      this.accountClasses = await firstValueFrom(this.onboarding.getAccountClasses());
    } catch (error) {
      this.accountClasses = [];
      this.pageError = 'Account classes could not be loaded from FCUBS. Please refresh and try again.';
      this.toast.error('Account classes unavailable', 'FCUBS account class configuration could not be loaded right now.');
    } finally {
      this.loadingAccountClasses = false;
    }
  }

  private ensureSelectedAccountClass(): void {
    const currentSelection = this.form.controls.accountClass.value || '';
    const selectedExists = this.accountClasses.some((item) => item.code === currentSelection);
    const fallbackSelection = selectedExists ? currentSelection : this.defaultAccountClassCode;
    this.syncAccountClassSelection(fallbackSelection);
  }

  private syncAccountClassSelection(accountClass: string): void {
    if (!accountClass) {
      return;
    }

    const selectedAccountClass = this.accountClasses.find((item) => item.code === accountClass);
    if (!selectedAccountClass) {
      return;
    }

    if (this.form.controls.accountClass.value !== selectedAccountClass.code) {
      this.form.controls.accountClass.setValue(selectedAccountClass.code, { emitEvent: false });
    }

    this.form.controls.accountNumberTemplate.setValue(
      this.buildAccountReferenceTemplate(selectedAccountClass.code),
      { emitEvent: false }
    );
    this.applyOpeningAmountValidators();
  }

  private applyOpeningAmountValidators(): void {
    const control = this.form.controls.openingAmount;
    const minimumOpeningAmount = Math.max(0, this.minimumOpeningAmount);
    control.setValidators([Validators.required, Validators.min(minimumOpeningAmount || 1)]);

    const currentAmount = Number(control.value || 0);
    if (!Number.isFinite(currentAmount) || currentAmount < minimumOpeningAmount) {
      control.setValue(minimumOpeningAmount || 1, { emitEvent: false });
    }

    control.updateValueAndValidity({ emitEvent: false });
  }

  private validateFundingSourceSelection(): string | null {
    return null;
  }

  private validateOpeningAmount(): string | null {
    const openingAmount = Number(this.form.controls.openingAmount.value || 0);
    if (!Number.isFinite(openingAmount) || openingAmount <= 0) {
      return 'Opening amount is required before continuing.';
    }

    if (openingAmount < this.minimumOpeningAmount) {
      return `Opening amount for ${this.form.controls.accountClass.value} must be at least ${this.minimumOpeningAmount} ${this.selectedAccountCurrencyCode}.`;
    }

    return null;
  }
}
