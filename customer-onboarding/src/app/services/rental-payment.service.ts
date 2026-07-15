import { HttpClient, HttpParams } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import {
  RentalPaymentInquiryResult,
  RentalPaymentRecord,
  RentalPaymentStatusResult,
  RentalPaymentSubmitRequest
} from '../models/onboarding.models';
import { environment } from 'src/environments/environment';

@Injectable({ providedIn: 'root' })
export class RentalPaymentService {
  private readonly baseUrl = `${environment.api.coreBaseUrl}/rental-payments`;

  constructor(private http: HttpClient) {}

  inquiry(billId: string, balerId: string): Observable<RentalPaymentInquiryResult> {
    return this.http.post<RentalPaymentInquiryResult>(`${this.baseUrl}/inquiry`, { billId, balerId });
  }

  pay(payload: RentalPaymentSubmitRequest): Observable<RentalPaymentRecord> {
    return this.http.post<RentalPaymentRecord>(`${this.baseUrl}/submit`, payload);
  }

  getMine(): Observable<RentalPaymentRecord[]> {
    return this.http.get<RentalPaymentRecord[]>(`${this.baseUrl}/mine`);
  }

  getPending(): Observable<RentalPaymentRecord[]> {
    return this.http.get<RentalPaymentRecord[]>(`${this.baseUrl}/pending`);
  }

  getCompleted(): Observable<RentalPaymentRecord[]> {
    return this.http.get<RentalPaymentRecord[]>(`${this.baseUrl}/completed`);
  }

  approve(id: number, checkerComment: string): Observable<RentalPaymentRecord> {
    return this.http.post<RentalPaymentRecord>(`${this.baseUrl}/${id}/approve`, { checkerComment });
  }

  reject(id: number, rejectionReason: string): Observable<RentalPaymentRecord> {
    return this.http.post<RentalPaymentRecord>(`${this.baseUrl}/${id}/reject`, { rejectionReason });
  }

  getStatus(manifestId: string, billId: string): Observable<RentalPaymentStatusResult> {
    const params = new HttpParams()
      .set('manifestId', manifestId)
      .set('billId', billId);

    return this.http.get<RentalPaymentStatusResult>(`${this.baseUrl}/status`, { params });
  }
}
