import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { AuthGuard } from './guards/auth.guard';
import { AccountCreationComponent } from './pages/account-creation/account-creation.component';
import { ApprovedAccountsComponent } from './pages/approved-accounts/approved-accounts.component';
import { CheckerDashboardComponent } from './pages/checker-dashboard/checker-dashboard.component';
import { ChangePasswordComponent } from './pages/change-password/change-password.component';
import { CustomerDetailsComponent } from './pages/customer-details/customer-details.component';
import { FanVerificationComponent } from './pages/fan-verification/fan-verification.component';
import { LoginComponent } from './pages/login/login.component';
import { OnboardingReportComponent } from './pages/onboarding-report/onboarding-report.component';
import { RentalApprovalsComponent } from './pages/rental-approvals/rental-approvals.component';
import { RentalPaymentComponent } from './pages/rental-payment/rental-payment.component';
import { ReviewSubmitComponent } from './pages/review-submit/review-submit.component';
import { TelebirrApprovalsComponent } from './pages/telebirr-approvals/telebirr-approvals.component';
import { TelebirrReportComponent } from './pages/telebirr-report/telebirr-report.component';
import { TelebirrTransferComponent } from './pages/telebirr-transfer/telebirr-transfer.component';
import { UserManagementComponent } from './pages/user-management/user-management.component';
import { WorkspaceHomeComponent } from './pages/workspace-home/workspace-home.component';
import { environment } from 'src/environments/environment';

const routes: Routes = [
  { path: '', pathMatch: 'full', redirectTo: 'login' },
  { path: 'login', component: LoginComponent },
  { path: 'change-password', component: ChangePasswordComponent, canActivate: [AuthGuard] },
  { path: 'workspace', component: WorkspaceHomeComponent, canActivate: [AuthGuard] },
  { path: 'fan-verification', component: FanVerificationComponent, canActivate: [AuthGuard], data: { roles: ['MAKER'] } },
  { path: 'customer-details', component: CustomerDetailsComponent, canActivate: [AuthGuard], data: { roles: ['MAKER'] } },
  { path: 'review-submit', component: ReviewSubmitComponent, canActivate: [AuthGuard], data: { roles: ['MAKER'] } },
  { path: 'account-creation', component: AccountCreationComponent, canActivate: [AuthGuard], data: { roles: ['MAKER'] } },
  { path: 'onboarding-report', component: OnboardingReportComponent, canActivate: [AuthGuard], data: { roles: ['ADMIN', 'REPORT_VIEWER', 'KYC_UNIT'] } },
  ...(environment.features.rentalPaymentEnabled ? [
    { path: 'rental-payment', component: RentalPaymentComponent, canActivate: [AuthGuard], data: { roles: ['RENTAL_MAKER'] } },
    { path: 'rental-approvals', component: RentalApprovalsComponent, canActivate: [AuthGuard], data: { roles: ['RENTAL_CHECKER'] } }
  ] : []),
  ...(environment.features.telebirrEnabled ? [
    { path: 'telebirr-transfer', component: TelebirrTransferComponent, canActivate: [AuthGuard], data: { roles: ['MAKER'] } },
    { path: 'telebirr-report', component: TelebirrReportComponent, canActivate: [AuthGuard], data: { roles: ['ADMIN', 'MAKER', 'CHECKER', 'REPORT_VIEWER'] } },
    { path: 'telebirr-approvals', component: TelebirrApprovalsComponent, canActivate: [AuthGuard], data: { roles: ['CHECKER'] } }
  ] : []),
  { path: 'checker-dashboard', component: CheckerDashboardComponent, canActivate: [AuthGuard], data: { roles: ['CHECKER'] } },
  { path: 'approved-accounts', component: ApprovedAccountsComponent, canActivate: [AuthGuard], data: { roles: ['MAKER', 'CHECKER'] } },
  { path: 'user-management', component: UserManagementComponent, canActivate: [AuthGuard], data: { roles: ['ADMIN'] } },
  { path: '**', redirectTo: 'login' }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule {}
