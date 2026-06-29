import { HttpClient, HttpParams } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import {
  ApprovalRecord,
  ApprovalSubmissionPayload,
  OnboardingDashboardStats,
  OnboardingReportQuery,
  OnboardingReportResponse
} from '../models/onboarding.models';
import { environment } from 'src/environments/environment';

@Injectable({ providedIn: 'root' })
export class ApprovalWorkflowService {
  private readonly baseUrl = `${environment.api.coreBaseUrl}/onboarding-records`;

  constructor(private http: HttpClient) {}

  submitForApproval(payload: ApprovalSubmissionPayload): Observable<ApprovalRecord> {
    return this.http.post<ApprovalRecord>(this.baseUrl, payload);
  }

  getPendingApprovals(): Observable<ApprovalRecord[]> {
    return this.http.get<ApprovalRecord[]>(`${this.baseUrl}/pending`);
  }

  getCompletedRecords(): Observable<ApprovalRecord[]> {
    return this.http.get<ApprovalRecord[]>(`${this.baseUrl}/completed`);
  }

  getReport(query: OnboardingReportQuery): Observable<OnboardingReportResponse> {
    let params = new HttpParams();
    Object.entries(query || {}).forEach(([key, value]) => {
      if (value === null || value === undefined || value === '') {
        return;
      }

      params = params.set(key, String(value));
    });

    return this.http.get<OnboardingReportResponse>(`${this.baseUrl}/report`, { params });
  }

  getDashboardStats(query?: Pick<OnboardingReportQuery, 'fromDate' | 'toDate'>): Observable<OnboardingDashboardStats> {
    let params = new HttpParams();
    Object.entries(query || {}).forEach(([key, value]) => {
      if (value === null || value === undefined || value === '') {
        return;
      }

      params = params.set(key, String(value));
    });

    return this.http.get<OnboardingDashboardStats>(`${this.baseUrl}/dashboard-stats`, { params });
  }

  getMySubmissions(): Observable<ApprovalRecord[]> {
    return this.http.get<ApprovalRecord[]>(`${this.baseUrl}/mine`);
  }

  getRecord(id: string): Observable<ApprovalRecord> {
    return this.http.get<ApprovalRecord>(`${this.baseUrl}/${id}`);
  }

  approve(id: string, checkerComment: string): Observable<ApprovalRecord> {
    return this.http.post<ApprovalRecord>(`${this.baseUrl}/${id}/approve`, { checkerComment });
  }

  reject(id: string, checkerComment: string): Observable<ApprovalRecord> {
    return this.http.post<ApprovalRecord>(`${this.baseUrl}/${id}/reject`, { checkerComment });
  }

  markKycReviewed(id: string): Observable<ApprovalRecord> {
    return this.http.post<ApprovalRecord>(`${this.baseUrl}/${id}/kyc-review`, {});
  }
}
