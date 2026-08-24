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
import { EmployeeDirectoryManagementComponent } from './pages/employee-directory-management/employee-directory-management.component';
import { PasswordManagementComponent } from './pages/password-management/password-management.component';
import { PasswordMessageAuditLogComponent } from './pages/password-message-audit-log/password-message-audit-log.component';
import { PasswordSmsTemplatesComponent } from './pages/password-sms-templates/password-sms-templates.component';
import { ResourceMobilizationApprovalsComponent } from './pages/resource-mobilization-approvals/resource-mobilization-approvals.component';
import { ResourceMobilizationReportComponent } from './pages/resource-mobilization-report/resource-mobilization-report.component';
import { ResourceMobilizationComponent } from './pages/resource-mobilization/resource-mobilization.component';
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
  { path: 'resource-mobilization', component: ResourceMobilizationComponent, canActivate: [AuthGuard], data: { roles: ['MAKER'] } },
  { path: 'resource-mobilization-approvals', component: ResourceMobilizationApprovalsComponent, canActivate: [AuthGuard], data: { roles: ['CHECKER'] } },
  { path: 'resource-mobilization-report', component: ResourceMobilizationReportComponent, canActivate: [AuthGuard], data: { roles: ['ADMIN', 'SYSTEM_ADMIN', 'SENIOR_MANAGEMENT', 'BRANCH_BANKING', 'REPORT_VIEWER', 'MAKER', 'CHECKER'] } },
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
  { path: 'user-management', component: UserManagementComponent, canActivate: [AuthGuard], data: { roles: ['ADMIN', 'SYSTEM_ADMIN'] } },
  { path: 'password-management', component: PasswordManagementComponent, canActivate: [AuthGuard], data: { roles: ['ADMIN', 'SYSTEM_ADMIN'] } },
  { path: 'employee-directory', component: EmployeeDirectoryManagementComponent, canActivate: [AuthGuard], data: { roles: ['ADMIN', 'SYSTEM_ADMIN', 'HR'] } },
  { path: 'password-message-audit', component: PasswordMessageAuditLogComponent, canActivate: [AuthGuard], data: { roles: ['ADMIN', 'SYSTEM_ADMIN'] } },
  { path: 'password-sms-templates', component: PasswordSmsTemplatesComponent, canActivate: [AuthGuard], data: { roles: ['ADMIN'] } },
  { path: '**', redirectTo: 'login' }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule {}
