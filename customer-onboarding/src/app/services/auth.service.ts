import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { BehaviorSubject, Observable, tap } from 'rxjs';
import { AuthUser, ChangePasswordRequest, LoginResponse, UserRole } from '../models/onboarding.models';
import { environment } from 'src/environments/environment';

interface StoredAuthSession {
  token: string;
  expiresAtUtc: string;
  user: AuthUser;
}

@Injectable({ providedIn: 'root' })
export class AuthService {
  private readonly authUrl = `${environment.api.coreBaseUrl}/auth`;
  private readonly storageKey = 'customer_onboarding_auth_session';
  private readonly sessionSubject = new BehaviorSubject<StoredAuthSession | null>(this.readSession());

  readonly session$ = this.sessionSubject.asObservable();

  constructor(private http: HttpClient) {}

  login(username: string, password: string): Observable<LoginResponse> {
    return this.http.post<LoginResponse>(`${this.authUrl}/login`, { username, password }).pipe(
      tap((response) => {
        const session: StoredAuthSession = {
          token: response.token,
          expiresAtUtc: response.expiresAtUtc,
          user: response.user
        };
        localStorage.setItem(this.storageKey, JSON.stringify(session));
        this.sessionSubject.next(session);
      })
    );
  }

  loadCurrentUser(): Observable<AuthUser> {
    return this.http.get<AuthUser>(`${this.authUrl}/me`).pipe(
      tap((user) => {
        const session = this.sessionSubject.value;
        if (session) {
          const updated = { ...session, user };
          localStorage.setItem(this.storageKey, JSON.stringify(updated));
          this.sessionSubject.next(updated);
        }
      })
    );
  }

  changePassword(payload: ChangePasswordRequest): Observable<AuthUser> {
    return this.http.post<AuthUser>(`${this.authUrl}/change-password`, payload).pipe(
      tap((user) => {
        const session = this.sessionSubject.value;
        if (!session) {
          return;
        }

        const updated = { ...session, user };
        localStorage.setItem(this.storageKey, JSON.stringify(updated));
        this.sessionSubject.next(updated);
      })
    );
  }

  logout(): void {
    localStorage.removeItem(this.storageKey);
    this.sessionSubject.next(null);
  }

  getToken(): string {
    return this.sessionSubject.value?.token || '';
  }

  getCurrentUser(): AuthUser | null {
    return this.sessionSubject.value?.user || null;
  }

  getBranchCode(): string {
    return this.getCurrentUser()?.branchCode || '';
  }

  isAuthenticated(): boolean {
    const session = this.sessionSubject.value;
    if (!session?.token || !session?.expiresAtUtc) {
      return false;
    }

    return new Date(session.expiresAtUtc).getTime() > Date.now();
  }

  hasRole(roles: UserRole[]): boolean {
    const role = this.getCurrentUser()?.role;
    return !!role && roles.includes(role);
  }

  mustChangePassword(): boolean {
    return !!this.getCurrentUser()?.mustChangePassword;
  }

  private readSession(): StoredAuthSession | null {
    const raw = localStorage.getItem(this.storageKey);
    if (!raw) {
      return null;
    }

    try {
      return JSON.parse(raw) as StoredAuthSession;
    } catch {
      return null;
    }
  }
}
