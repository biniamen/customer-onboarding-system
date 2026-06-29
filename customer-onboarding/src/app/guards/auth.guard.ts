import { Injectable } from '@angular/core';
import { ActivatedRouteSnapshot, CanActivate, Router, RouterStateSnapshot } from '@angular/router';
import { AuthService } from '../services/auth.service';
import { UserRole } from '../models/onboarding.models';

@Injectable({ providedIn: 'root' })
export class AuthGuard implements CanActivate {
  constructor(private auth: AuthService, private router: Router) {}

  canActivate(route: ActivatedRouteSnapshot, _state: RouterStateSnapshot): boolean {
    if (!this.auth.isAuthenticated()) {
      this.router.navigate(['/login']);
      return false;
    }

    const isChangePasswordRoute = route.routeConfig?.path === 'change-password';
    if (this.auth.mustChangePassword() && !isChangePasswordRoute) {
      this.router.navigate(['/change-password']);
      return false;
    }

    const roles = (route.data['roles'] || []) as UserRole[];
    if (roles.length && !this.auth.hasRole(roles)) {
      this.router.navigate(['/workspace']);
      return false;
    }

    return true;
  }
}
