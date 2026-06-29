import { Injectable } from '@angular/core';
import { AdditionalCustomerDetails, FcubsSubmissionResult, NidEkycRoot } from '../models/onboarding.models';

@Injectable({
  providedIn: 'root'
})
export class CustomerSessionService {
  private readonly KEY_FAN = 'nid_fan';
  private readonly KEY_FAN_TXN = 'nid_fan_txn';
  private readonly KEY_FAN_MASKED_MOBILE = 'nid_fan_masked_mobile';
  private readonly KEY_FAN_MASKED_EMAIL = 'nid_fan_masked_email';
  private readonly KEY_NID_IDENTITY = 'nid_identity';
  private readonly KEY_NID_EKYC_ROOT = 'nid_ekyc_root';
  private readonly KEY_ADDITIONAL_DETAILS = 'nid_additional_customer_details';
  private readonly KEY_FCUBS_RESPONSE = 'nid_fcubs_response';

  setFan(fan: string): void {
    sessionStorage.setItem(this.KEY_FAN, fan || '');
  }

  getFan(): string {
    return sessionStorage.getItem(this.KEY_FAN) || '';
  }

  setFanOtpMeta(txnId: string, maskedMobile: string, maskedEmail: string): void {
    sessionStorage.setItem(this.KEY_FAN_TXN, txnId || '');
    sessionStorage.setItem(this.KEY_FAN_MASKED_MOBILE, maskedMobile || '');
    sessionStorage.setItem(this.KEY_FAN_MASKED_EMAIL, maskedEmail || '');
  }

  getFanTxnId(): string {
    return sessionStorage.getItem(this.KEY_FAN_TXN) || '';
  }

  getFanMaskedMobile(): string {
    return sessionStorage.getItem(this.KEY_FAN_MASKED_MOBILE) || '';
  }

  getFanMaskedEmail(): string {
    return sessionStorage.getItem(this.KEY_FAN_MASKED_EMAIL) || '';
  }

  setNidEkycRoot(root: NidEkycRoot | null): void {
    sessionStorage.setItem(this.KEY_NID_EKYC_ROOT, JSON.stringify(root || {}));

    const identity = root?.identity;
    if (identity) {
      this.setNidIdentity(identity);
    }
  }

  getNidEkycRoot<T = NidEkycRoot>(): T | null {
    const raw = sessionStorage.getItem(this.KEY_NID_EKYC_ROOT);
    if (!raw) {
      return null;
    }

    try {
      return JSON.parse(raw) as T;
    } catch {
      return null;
    }
  }

  getPsut(): string {
    const root = this.getNidEkycRoot<NidEkycRoot>();
    return (root?.psut || '').toString().trim();
  }

  clearNidEkycRoot(): void {
    sessionStorage.removeItem(this.KEY_NID_EKYC_ROOT);
  }

  setNidIdentity(identity: any): void {
    if (identity && identity.identity && (identity.psut || identity.kycStatus !== undefined)) {
      this.setNidEkycRoot(identity as NidEkycRoot);
      return;
    }

    sessionStorage.setItem(this.KEY_NID_IDENTITY, JSON.stringify(identity || {}));
  }

  getNidIdentity<T = any>(): T | null {
    const root = this.getNidEkycRoot<NidEkycRoot>();
    if (root?.identity) {
      return root.identity as T;
    }

    const raw = sessionStorage.getItem(this.KEY_NID_IDENTITY);
    if (!raw) {
      return null;
    }

    try {
      return JSON.parse(raw) as T;
    } catch {
      return null;
    }
  }

  setAdditionalDetails(details: AdditionalCustomerDetails): void {
    sessionStorage.setItem(this.KEY_ADDITIONAL_DETAILS, JSON.stringify(details || null));
  }

  getAdditionalDetails<T = AdditionalCustomerDetails>(): T | null {
    const raw = sessionStorage.getItem(this.KEY_ADDITIONAL_DETAILS);
    if (!raw) {
      return null;
    }

    try {
      return JSON.parse(raw) as T;
    } catch {
      return null;
    }
  }

  setFcubsResponse(response: FcubsSubmissionResult): void {
    sessionStorage.setItem(this.KEY_FCUBS_RESPONSE, JSON.stringify(response || null));
  }

  getFcubsResponse<T = FcubsSubmissionResult>(): T | null {
    const raw = sessionStorage.getItem(this.KEY_FCUBS_RESPONSE);
    if (!raw) {
      return null;
    }

    try {
      return JSON.parse(raw) as T;
    } catch {
      return null;
    }
  }

  clearAll(): void {
    [
      this.KEY_FAN,
      this.KEY_FAN_TXN,
      this.KEY_FAN_MASKED_MOBILE,
      this.KEY_FAN_MASKED_EMAIL,
      this.KEY_NID_IDENTITY,
      this.KEY_NID_EKYC_ROOT,
      this.KEY_ADDITIONAL_DETAILS,
      this.KEY_FCUBS_RESPONSE
    ].forEach((key) => sessionStorage.removeItem(key));
  }
}
