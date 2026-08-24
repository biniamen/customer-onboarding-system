import { HttpClient, HttpParams } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import {
  ResourceMobilizationDashboardStats,
  ResourceMobilizationEmployeeSearchResult,
  ResourceMobilizationRecord,
  ResourceMobilizationReportQuery,
  ResourceMobilizationReportResponse,
  ResourceMobilizationSubmitRequest,
  ResourceMobilizationTransactionLookupRequest,
  ResourceMobilizationTransactionResult
} from '../models/onboarding.models';
import { environment } from 'src/environments/environment';

@Injectable({ providedIn: 'root' })
export class ResourceMobilizationService {
  private readonly baseUrl = `${environment.api.coreBaseUrl}/resource-mobilization`;

  constructor(private http: HttpClient) {}

  searchEmployees(search: string, limit = 20): Observable<ResourceMobilizationEmployeeSearchResult[]> {
    let params = new HttpParams()
      .set('search', search.trim())
      .set('limit', String(limit));

    return this.http.get<ResourceMobilizationEmployeeSearchResult[]>(`${this.baseUrl}/employees`, { params });
  }

  searchTransactions(payload: ResourceMobilizationTransactionLookupRequest): Observable<ResourceMobilizationTransactionResult[]> {
    return this.http.post<ResourceMobilizationTransactionResult[]>(`${this.baseUrl}/transactions/search`, payload);
  }

  submit(payload: ResourceMobilizationSubmitRequest): Observable<ResourceMobilizationRecord> {
    return this.http.post<ResourceMobilizationRecord>(`${this.baseUrl}/submit`, payload);
  }

  getMine(): Observable<ResourceMobilizationRecord[]> {
    return this.http.get<ResourceMobilizationRecord[]>(`${this.baseUrl}/mine`);
  }

  getPending(): Observable<ResourceMobilizationRecord[]> {
    return this.http.get<ResourceMobilizationRecord[]>(`${this.baseUrl}/pending`);
  }

  getCompleted(): Observable<ResourceMobilizationRecord[]> {
    return this.http.get<ResourceMobilizationRecord[]>(`${this.baseUrl}/completed`);
  }

  getById(id: number): Observable<ResourceMobilizationRecord> {
    return this.http.get<ResourceMobilizationRecord>(`${this.baseUrl}/${id}`);
  }

  approve(id: number, checkerComment: string): Observable<ResourceMobilizationRecord> {
    return this.http.post<ResourceMobilizationRecord>(`${this.baseUrl}/${id}/approve`, { checkerComment });
  }

  reject(id: number, rejectionReason: string): Observable<ResourceMobilizationRecord> {
    return this.http.post<ResourceMobilizationRecord>(`${this.baseUrl}/${id}/reject`, { rejectionReason });
  }

  remove(id: number): Observable<void> {
    return this.http.delete<void>(`${this.baseUrl}/${id}`);
  }

  getReport(query: ResourceMobilizationReportQuery): Observable<ResourceMobilizationReportResponse> {
    let params = new HttpParams();
    Object.entries(query || {}).forEach(([key, value]) => {
      if (value === null || value === undefined || value === '') {
        return;
      }

      params = params.set(key, String(value));
    });

    return this.http.get<ResourceMobilizationReportResponse>(`${this.baseUrl}/report`, { params });
  }

  getDashboardStats(): Observable<ResourceMobilizationDashboardStats> {
    return this.http.get<ResourceMobilizationDashboardStats>(`${this.baseUrl}/dashboard-stats`);
  }
}
