import { Injectable } from '@angular/core';
import {
  AccountCreationResult,
  AccountOpeningDetails,
  AdditionalCustomerDetails,
  FcubsSubmissionResult,
  NidEkycRoot
} from '../models/onboarding.models';

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
  private readonly KEY_ACCOUNT_OPENING_DETAILS = 'nid_account_opening_details';
  private readonly KEY_ACCOUNT_CREATION_RESPONSE = 'nid_account_creation_response';
  private readonly ACCOUNT_OPENING_DB = 'customer-onboarding-attachments';
  private readonly ACCOUNT_OPENING_STORE = 'account-opening-details';
  private readonly ACCOUNT_OPENING_RECORD_KEY = 'current';
  private accountOpeningDetailsCache: AccountOpeningDetails | null = null;

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

  async setAccountOpeningDetails(details: AccountOpeningDetails): Promise<void> {
    // Base64 images and documents easily exceed sessionStorage's small quota.
    // Keep the temporary KYC attachments in IndexedDB until the case is submitted.
    this.accountOpeningDetailsCache = details || null;
    sessionStorage.removeItem(this.KEY_ACCOUNT_OPENING_DETAILS);

    if (!details) {
      await this.removeAccountOpeningDetailsFromIndexedDb();
      return;
    }

    try {
      await this.saveAccountOpeningDetailsToIndexedDb(details);
    } catch {
      // The in-memory copy still supports the active onboarding flow if browser
      // storage is unavailable. The request itself always carries the assets.
    }
  }

  async getAccountOpeningDetails<T = AccountOpeningDetails>(): Promise<T | null> {
    if (this.accountOpeningDetailsCache) {
      return this.accountOpeningDetailsCache as unknown as T;
    }

    try {
      const indexedDetails = await this.getAccountOpeningDetailsFromIndexedDb();
      if (indexedDetails) {
        this.accountOpeningDetailsCache = indexedDetails;
        return indexedDetails as unknown as T;
      }
    } catch {
      // Fall through to the legacy session value for a case started before this update.
    }

    const raw = sessionStorage.getItem(this.KEY_ACCOUNT_OPENING_DETAILS);
    if (!raw) {
      return null;
    }

    try {
      const details = JSON.parse(raw) as T;
      this.accountOpeningDetailsCache = details as unknown as AccountOpeningDetails;
      return details;
    } catch {
      return null;
    }
  }

  setAccountCreationResponse(response: AccountCreationResult): void {
    sessionStorage.setItem(this.KEY_ACCOUNT_CREATION_RESPONSE, JSON.stringify(response || null));
  }

  getAccountCreationResponse<T = AccountCreationResult>(): T | null {
    const raw = sessionStorage.getItem(this.KEY_ACCOUNT_CREATION_RESPONSE);
    if (!raw) {
      return null;
    }

    try {
      return JSON.parse(raw) as T;
    } catch {
      return null;
    }
  }

  async clearAll(): Promise<void> {
    [
      this.KEY_FAN,
      this.KEY_FAN_TXN,
      this.KEY_FAN_MASKED_MOBILE,
      this.KEY_FAN_MASKED_EMAIL,
      this.KEY_NID_IDENTITY,
      this.KEY_NID_EKYC_ROOT,
      this.KEY_ADDITIONAL_DETAILS,
      this.KEY_FCUBS_RESPONSE,
      this.KEY_ACCOUNT_OPENING_DETAILS,
      this.KEY_ACCOUNT_CREATION_RESPONSE
    ].forEach((key) => sessionStorage.removeItem(key));
    this.accountOpeningDetailsCache = null;
    await this.removeAccountOpeningDetailsFromIndexedDb();
  }

  private openAccountOpeningDatabase(): Promise<IDBDatabase> {
    return new Promise((resolve, reject) => {
      if (!('indexedDB' in window)) {
        reject(new Error('Browser attachment storage is unavailable.'));
        return;
      }

      const request = window.indexedDB.open(this.ACCOUNT_OPENING_DB, 1);
      request.onupgradeneeded = () => {
        const database = request.result;
        if (!database.objectStoreNames.contains(this.ACCOUNT_OPENING_STORE)) {
          database.createObjectStore(this.ACCOUNT_OPENING_STORE);
        }
      };
      request.onsuccess = () => resolve(request.result);
      request.onerror = () => reject(request.error || new Error('Unable to open browser attachment storage.'));
    });
  }

  private async saveAccountOpeningDetailsToIndexedDb(details: AccountOpeningDetails): Promise<void> {
    const database = await this.openAccountOpeningDatabase();

    return new Promise((resolve, reject) => {
      const transaction = database.transaction(this.ACCOUNT_OPENING_STORE, 'readwrite');
      transaction.objectStore(this.ACCOUNT_OPENING_STORE).put(details, this.ACCOUNT_OPENING_RECORD_KEY);
      transaction.oncomplete = () => {
        database.close();
        resolve();
      };
      transaction.onerror = () => {
        database.close();
        reject(transaction.error || new Error('Unable to save temporary attachments.'));
      };
      transaction.onabort = () => {
        database.close();
        reject(transaction.error || new Error('Temporary attachment storage was cancelled.'));
      };
    });
  }

  private async getAccountOpeningDetailsFromIndexedDb(): Promise<AccountOpeningDetails | null> {
    const database = await this.openAccountOpeningDatabase();

    return new Promise((resolve, reject) => {
      const transaction = database.transaction(this.ACCOUNT_OPENING_STORE, 'readonly');
      const request = transaction.objectStore(this.ACCOUNT_OPENING_STORE).get(this.ACCOUNT_OPENING_RECORD_KEY);
      request.onsuccess = () => {
        database.close();
        resolve((request.result as AccountOpeningDetails | undefined) || null);
      };
      request.onerror = () => {
        database.close();
        reject(request.error || new Error('Unable to read temporary attachments.'));
      };
    });
  }

  private async removeAccountOpeningDetailsFromIndexedDb(): Promise<void> {
    try {
      const database = await this.openAccountOpeningDatabase();
      await new Promise<void>((resolve, reject) => {
        const transaction = database.transaction(this.ACCOUNT_OPENING_STORE, 'readwrite');
        transaction.objectStore(this.ACCOUNT_OPENING_STORE).delete(this.ACCOUNT_OPENING_RECORD_KEY);
        transaction.oncomplete = () => {
          database.close();
          resolve();
        };
        transaction.onerror = () => {
          database.close();
          reject(transaction.error || new Error('Unable to clear temporary attachments.'));
        };
      });
    } catch {
      // There is nothing further to clear when IndexedDB is unavailable.
    }
  }
}
