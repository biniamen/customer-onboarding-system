import { HttpClient } from '@angular/common/http';
import { HttpParams } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import {
  TelebirrAccountLookupResult,
  TelebirrAgentLookupResult,
  TelebirrDashboardStats,
  TelebirrTransferReportQuery,
  TelebirrTransferReportResponse,
  TelebirrTransferRecord,
  TelebirrTransferSubmitRequest
} from '../models/onboarding.models';
import { environment } from 'src/environments/environment';

@Injectable({ providedIn: 'root' })
export class TelebirrTransferService {
  private readonly baseUrl = `${environment.api.coreBaseUrl}/telebirr-transfers`;

  constructor(private http: HttpClient) {}

  lookupAccount(accountNumber: string): Observable<TelebirrAccountLookupResult> {
    return this.http.post<TelebirrAccountLookupResult>(`${this.baseUrl}/account-lookup`, { accountNumber });
  }

  lookupAgent(telebirrShortCode: string): Observable<TelebirrAgentLookupResult> {
    return this.http.post<TelebirrAgentLookupResult>(`${this.baseUrl}/agent-lookup`, { telebirrShortCode });
  }

  submit(payload: TelebirrTransferSubmitRequest): Observable<TelebirrTransferRecord> {
    return this.http.post<TelebirrTransferRecord>(`${this.baseUrl}/submit`, payload);
  }

  getMine(): Observable<TelebirrTransferRecord[]> {
    return this.http.get<TelebirrTransferRecord[]>(`${this.baseUrl}/mine`);
  }

  getPending(): Observable<TelebirrTransferRecord[]> {
    return this.http.get<TelebirrTransferRecord[]>(`${this.baseUrl}/pending`);
  }

  getCompleted(): Observable<TelebirrTransferRecord[]> {
    return this.http.get<TelebirrTransferRecord[]>(`${this.baseUrl}/completed`);
  }

  getReport(query: TelebirrTransferReportQuery): Observable<TelebirrTransferReportResponse> {
    let params = new HttpParams();
    Object.entries(query || {}).forEach(([key, value]) => {
      if (value === null || value === undefined || value === '') {
        return;
      }

      params = params.set(key, String(value));
    });

    return this.http.get<TelebirrTransferReportResponse>(`${this.baseUrl}/report`, { params });
  }

  getDashboardStats(query?: Pick<TelebirrTransferReportQuery, 'fromDate' | 'toDate'>): Observable<TelebirrDashboardStats> {
    let params = new HttpParams();
    Object.entries(query || {}).forEach(([key, value]) => {
      if (value === null || value === undefined || value === '') {
        return;
      }

      params = params.set(key, String(value));
    });

    return this.http.get<TelebirrDashboardStats>(`${this.baseUrl}/dashboard-stats`, { params });
  }

  approve(id: number, checkerComment: string): Observable<TelebirrTransferRecord> {
    return this.http.post<TelebirrTransferRecord>(`${this.baseUrl}/${id}/approve`, { checkerComment });
  }

  reject(id: number, rejectionReason: string): Observable<TelebirrTransferRecord> {
    return this.http.post<TelebirrTransferRecord>(`${this.baseUrl}/${id}/reject`, { rejectionReason });
  }
}
