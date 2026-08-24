import { Component } from '@angular/core';
import { AuthService } from 'src/app/services/auth.service';
import { environment } from 'src/environments/environment';

@Component({
  selector: 'app-workspace-home',
  templateUrl: './workspace-home.component.html',
  styleUrls: ['./workspace-home.component.css']
})
export class WorkspaceHomeComponent {
  readonly telebirrEnabled = environment.features.telebirrEnabled;
  readonly rentalPaymentEnabled = environment.features.rentalPaymentEnabled;

  constructor(private auth: AuthService) {}

  get isMaker(): boolean {
    return this.auth.getCurrentUser()?.role === 'MAKER';
  }

  get isChecker(): boolean {
    return this.auth.getCurrentUser()?.role === 'CHECKER';
  }

  get isRentalMaker(): boolean {
    return this.auth.getCurrentUser()?.role === 'RENTAL_MAKER';
  }

  get isRentalChecker(): boolean {
    return this.auth.getCurrentUser()?.role === 'RENTAL_CHECKER';
  }

  get isReportViewer(): boolean {
    return this.auth.getCurrentUser()?.role === 'REPORT_VIEWER';
  }

  get isSeniorManagement(): boolean {
    return this.auth.getCurrentUser()?.role === 'SENIOR_MANAGEMENT';
  }

  get isBranchBanking(): boolean {
    return this.auth.getCurrentUser()?.role === 'BRANCH_BANKING';
  }

  get isHr(): boolean {
    return this.auth.getCurrentUser()?.role === 'HR';
  }

  get isKycUnit(): boolean {
    return this.auth.getCurrentUser()?.role === 'KYC_UNIT';
  }

  get isAdmin(): boolean {
    return this.auth.getCurrentUser()?.role === 'ADMIN';
  }

  get isSystemAdmin(): boolean {
    return this.auth.getCurrentUser()?.role === 'SYSTEM_ADMIN';
  }

  get canManageSecurity(): boolean {
    const role = this.auth.getCurrentUser()?.role;
    return role === 'ADMIN' || role === 'SYSTEM_ADMIN';
  }

  get canManageEmployeeDirectory(): boolean {
    const role = this.auth.getCurrentUser()?.role;
    return role === 'ADMIN' || role === 'SYSTEM_ADMIN' || role === 'HR';
  }

  get canAccessTelebirrReport(): boolean {
    const role = this.auth.getCurrentUser()?.role;
    return role === 'ADMIN' || role === 'MAKER' || role === 'CHECKER' || role === 'REPORT_VIEWER';
  }

  get canAccessResourceMobilizationReport(): boolean {
    const role = this.auth.getCurrentUser()?.role;
    return role === 'ADMIN' || role === 'SYSTEM_ADMIN' || role === 'SENIOR_MANAGEMENT' || role === 'BRANCH_BANKING' || role === 'MAKER' || role === 'CHECKER' || role === 'REPORT_VIEWER';
  }
}
