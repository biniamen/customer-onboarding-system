import { HttpClientModule } from '@angular/common/http';
import { HTTP_INTERCEPTORS } from '@angular/common/http';
import { NgModule } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { ReactiveFormsModule } from '@angular/forms';
import { BrowserModule } from '@angular/platform-browser';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { StepperComponent } from './components/stepper/stepper.component';
import { ToastStackComponent } from './components/toast-stack/toast-stack.component';
import { AuthInterceptor } from './services/auth.interceptor';
import { AccountCreationComponent } from './pages/account-creation/account-creation.component';
import { ApprovedAccountsComponent } from './pages/approved-accounts/approved-accounts.component';
import { ChangePasswordComponent } from './pages/change-password/change-password.component';
import { CheckerDashboardComponent } from './pages/checker-dashboard/checker-dashboard.component';
import { CustomerDetailsComponent } from './pages/customer-details/customer-details.component';
import { FanVerificationComponent } from './pages/fan-verification/fan-verification.component';
import { LoginComponent } from './pages/login/login.component';
import { OnboardingReportComponent } from './pages/onboarding-report/onboarding-report.component';
import { ReviewSubmitComponent } from './pages/review-submit/review-submit.component';
import { TelebirrApprovalsComponent } from './pages/telebirr-approvals/telebirr-approvals.component';
import { TelebirrReportComponent } from './pages/telebirr-report/telebirr-report.component';
import { TelebirrTransferComponent } from './pages/telebirr-transfer/telebirr-transfer.component';
import { UserManagementComponent } from './pages/user-management/user-management.component';
import { WorkspaceHomeComponent } from './pages/workspace-home/workspace-home.component';

@NgModule({
  declarations: [
    AppComponent,
    ChangePasswordComponent,
    FanVerificationComponent,
    CustomerDetailsComponent,
    ReviewSubmitComponent,
    AccountCreationComponent,
    OnboardingReportComponent,
    ApprovedAccountsComponent,
    TelebirrTransferComponent,
    TelebirrApprovalsComponent,
    TelebirrReportComponent,
    UserManagementComponent,
    WorkspaceHomeComponent,
    LoginComponent,
    CheckerDashboardComponent,
    ToastStackComponent,
    StepperComponent
  ],
  imports: [
    BrowserModule,
    HttpClientModule,
    FormsModule,
    ReactiveFormsModule,
    AppRoutingModule
  ],
  providers: [
    {
      provide: HTTP_INTERCEPTORS,
      useClass: AuthInterceptor,
      multi: true
    }
  ],
  bootstrap: [AppComponent]
})
export class AppModule {}
