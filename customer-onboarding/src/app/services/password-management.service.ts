import { HttpClient, HttpParams } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { environment } from 'src/environments/environment';
import {
  EmployeeDirectoryEntryRecord,
  EmployeeDirectoryImportResult,
  EmployeeDirectoryPagedResponse,
  EmployeeDirectoryQuery,
  EmployeeDirectoryStats,
  ExternalDirectoryUser,
  PasswordMessageAuditLogQuery,
  PasswordMessageAuditLogResponse,
  PasswordMessageDispatchResult,
  PasswordManagedSystem,
  PasswordMessageTemplate,
  SendNewUserCredentialSmsRequest,
  SendPasswordResetSmsRequest,
  UpdateEmployeeDirectoryEntryRequest,
  UpdatePasswordMessageTemplateRequest
} from '../models/onboarding.models';

@Injectable({ providedIn: 'root' })
export class PasswordManagementService {
  private readonly baseUrl = `${environment.api.coreBaseUrl}/password-management`;
  private readonly employeeDirectoryUrl = `${environment.api.coreBaseUrl}/employee-directory`;
  private readonly auditLogsUrl = `${environment.api.coreBaseUrl}/audit-logs`;

  constructor(private http: HttpClient) {}

  getExternalUsers(search?: string, limit = 20): Observable<ExternalDirectoryUser[]> {
    let params = new HttpParams();
    if (search?.trim()) {
      params = params.set('search', search.trim());
    }
    params = params.set('limit', String(limit));

    return this.http.get<ExternalDirectoryUser[]>(`${this.baseUrl}/external-users`, { params });
  }

  getEmployeeDirectoryStats(): Observable<EmployeeDirectoryStats> {
    return this.http.get<EmployeeDirectoryStats>(`${this.baseUrl}/employee-directory/stats`);
  }

  importEmployeeDirectory(file: File): Observable<EmployeeDirectoryImportResult> {
    const formData = new FormData();
    formData.append('file', file, file.name);
    return this.http.post<EmployeeDirectoryImportResult>(`${this.baseUrl}/employee-directory/import`, formData);
  }

  getTemplates(): Observable<PasswordMessageTemplate[]> {
    return this.http.get<PasswordMessageTemplate[]>(`${this.baseUrl}/templates`);
  }

  getPasswordSystems(includeInactive = false): Observable<PasswordManagedSystem[]> {
    const params = includeInactive ? new HttpParams().set('includeInactive', 'true') : undefined;
    return this.http.get<PasswordManagedSystem[]>(`${this.baseUrl}/systems`, { params });
  }

  createPasswordSystem(name: string): Observable<PasswordManagedSystem> {
    return this.http.post<PasswordManagedSystem>(`${this.baseUrl}/systems`, { name });
  }

  updatePasswordSystem(id: number, name: string, isActive: boolean): Observable<PasswordManagedSystem> {
    return this.http.put<PasswordManagedSystem>(`${this.baseUrl}/systems/${id}`, { name, isActive });
  }

  saveTemplate(templateType: string, payload: UpdatePasswordMessageTemplateRequest): Observable<PasswordMessageTemplate> {
    return this.http.put<PasswordMessageTemplate>(`${this.baseUrl}/templates/${templateType}`, payload);
  }

  sendPasswordResetSms(payload: SendPasswordResetSmsRequest): Observable<PasswordMessageDispatchResult> {
    return this.http.post<PasswordMessageDispatchResult>(`${this.baseUrl}/send-reset-sms`, payload);
  }

  sendNewUserSms(payload: SendNewUserCredentialSmsRequest): Observable<PasswordMessageDispatchResult> {
    return this.http.post<PasswordMessageDispatchResult>(`${this.baseUrl}/send-new-user-sms`, payload);
  }

  getEmployeeDirectory(query: EmployeeDirectoryQuery): Observable<EmployeeDirectoryPagedResponse> {
    let params = new HttpParams();
    Object.entries(query || {}).forEach(([key, value]) => {
      if (value === null || value === undefined || value === '') {
        return;
      }

      params = params.set(key, String(value));
    });

    return this.http.get<EmployeeDirectoryPagedResponse>(this.employeeDirectoryUrl, { params });
  }

  getEmployeeDirectoryEntry(id: string): Observable<EmployeeDirectoryEntryRecord> {
    return this.http.get<EmployeeDirectoryEntryRecord>(`${this.employeeDirectoryUrl}/${id}`);
  }

  updateEmployeeDirectoryEntry(id: string, payload: UpdateEmployeeDirectoryEntryRequest): Observable<EmployeeDirectoryEntryRecord> {
    return this.http.put<EmployeeDirectoryEntryRecord>(`${this.employeeDirectoryUrl}/${id}`, payload);
  }

  deleteEmployeeDirectoryEntry(id: string): Observable<void> {
    return this.http.delete<void>(`${this.employeeDirectoryUrl}/${id}`);
  }

  getPasswordMessageAuditLogs(query: PasswordMessageAuditLogQuery): Observable<PasswordMessageAuditLogResponse> {
    let params = new HttpParams();
    Object.entries(query || {}).forEach(([key, value]) => {
      if (value === null || value === undefined || value === '') {
        return;
      }

      params = params.set(key, String(value));
    });

    return this.http.get<PasswordMessageAuditLogResponse>(`${this.auditLogsUrl}/password-messages`, { params });
  }
}
