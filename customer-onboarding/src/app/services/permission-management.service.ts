import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import {
  CreateSystemPermissionRequest,
  PermissionManagementSnapshot,
  RolePermissionAssignment,
  SystemPermission,
  UpdateRolePermissionsRequest,
  UpdateSystemPermissionRequest,
  UserRole
} from '../models/onboarding.models';
import { environment } from 'src/environments/environment';

@Injectable({ providedIn: 'root' })
export class PermissionManagementService {
  private readonly baseUrl = `${environment.api.coreBaseUrl}/admin/permissions`;

  constructor(private http: HttpClient) {}

  getConfiguration(): Observable<PermissionManagementSnapshot> {
    return this.http.get<PermissionManagementSnapshot>(this.baseUrl);
  }

  createPermission(payload: CreateSystemPermissionRequest): Observable<SystemPermission> {
    return this.http.post<SystemPermission>(this.baseUrl, payload);
  }

  updatePermission(id: number, payload: UpdateSystemPermissionRequest): Observable<SystemPermission> {
    return this.http.put<SystemPermission>(`${this.baseUrl}/${id}`, payload);
  }

  deletePermission(id: number): Observable<void> {
    return this.http.delete<void>(`${this.baseUrl}/${id}`);
  }

  updateRoleAssignments(role: UserRole, payload: UpdateRolePermissionsRequest): Observable<RolePermissionAssignment> {
    return this.http.put<RolePermissionAssignment>(`${this.baseUrl}/roles/${encodeURIComponent(role)}/assignments`, payload);
  }
}
