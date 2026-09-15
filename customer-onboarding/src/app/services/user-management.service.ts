import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import {
  AdminUserListItem,
  BranchOption,
  CreateBranchRequest,
  CreateUserRequest,
  ManagedBranch,
  ResetUserPasswordRequest,
  UpdateBranchRequest,
  UpdateUserRequest
} from '../models/onboarding.models';
import { environment } from 'src/environments/environment';

@Injectable({ providedIn: 'root' })
export class UserManagementService {
  private readonly baseUrl = `${environment.api.coreBaseUrl}/admin`;

  constructor(private http: HttpClient) {}

  getBranches(): Observable<BranchOption[]> {
    return this.http.get<BranchOption[]>(`${this.baseUrl}/branches`);
  }

  getManagedBranches(): Observable<ManagedBranch[]> {
    return this.http.get<ManagedBranch[]>(`${this.baseUrl}/branches/manage`);
  }

  createBranch(payload: CreateBranchRequest): Observable<ManagedBranch> {
    return this.http.post<ManagedBranch>(`${this.baseUrl}/branches`, payload);
  }

  updateBranch(branchCode: string, payload: UpdateBranchRequest): Observable<ManagedBranch> {
    return this.http.put<ManagedBranch>(`${this.baseUrl}/branches/${encodeURIComponent(branchCode)}`, payload);
  }

  deleteBranch(branchCode: string): Observable<void> {
    return this.http.delete<void>(`${this.baseUrl}/branches/${encodeURIComponent(branchCode)}`);
  }

  getUsers(): Observable<AdminUserListItem[]> {
    return this.http.get<AdminUserListItem[]>(`${this.baseUrl}/users`);
  }

  createUser(payload: CreateUserRequest): Observable<AdminUserListItem> {
    return this.http.post<AdminUserListItem>(`${this.baseUrl}/users`, payload);
  }

  updateUser(id: string, payload: UpdateUserRequest): Observable<AdminUserListItem> {
    return this.http.put<AdminUserListItem>(`${this.baseUrl}/users/${id}`, payload);
  }

  resetPassword(id: string, payload: ResetUserPasswordRequest): Observable<AdminUserListItem> {
    return this.http.post<AdminUserListItem>(`${this.baseUrl}/users/${id}/reset-password`, payload);
  }
}
