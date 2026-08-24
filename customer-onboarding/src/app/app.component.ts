import { Component, OnDestroy } from '@angular/core';
import { NavigationEnd, Router } from '@angular/router';
import { filter, fromEvent, merge, Subscription } from 'rxjs';
import { AuthUser } from './models/onboarding.models';
import { AuthService } from './services/auth.service';
import { ToastService } from './services/toast.service';
import { environment } from 'src/environments/environment';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent implements OnDestroy {
  title = 'customer-onboarding';
  readonly logoPath = 'assets/branding/GB.png';
  readonly telebirrEnabled = environment.features.telebirrEnabled;
  readonly rentalPaymentEnabled = environment.features.rentalPaymentEnabled;

  readonly steps = [
    { label: 'Verify FAN', route: '/fan-verification' },
    { label: 'Complete Profile', route: '/customer-details' },
    { label: 'Review & Submit', route: '/review-submit' },
    { label: 'Open Account', route: '/account-creation' }
  ];

  currentRoute = '/login';
  currentUser: AuthUser | null = null;
  private readonly inactivityTimeoutMs = 3 * 60 * 1000;
  private inactivityTimer: ReturnType<typeof setTimeout> | null = null;
  private activitySubscription: Subscription | null = null;

  constructor(
    private router: Router,
    private auth: AuthService,
    private toast: ToastService
  ) {
    this.currentRoute = this.router.url || '/login';
    this.currentUser = this.auth.getCurrentUser();

    this.router.events
      .pipe(filter((event): event is NavigationEnd => event instanceof NavigationEnd))
      .subscribe((event) => {
        this.currentRoute = event.urlAfterRedirects;
      });

    this.auth.session$.subscribe((session) => {
      this.currentUser = session?.user || null;
      this.setupInactivityTracking(!!session?.user);
    });
  }

  ngOnDestroy(): void {
    this.clearInactivityTimer();
    this.activitySubscription?.unsubscribe();
    this.activitySubscription = null;
  }

  get showLoginLayout(): boolean {
    if (this.currentRoute.startsWith('/login')) {
      return true;
    }

    if (this.currentRoute.startsWith('/change-password')) {
      return !this.auth.isAuthenticated();
    }

    return false;
  }

  get showStepper(): boolean {
    return this.currentUser?.role === 'MAKER' && this.isOnboardingRoute;
  }

  get showOperationsNav(): boolean {
    return !!this.currentUser && !this.showLoginLayout;
  }

  get shellTitle(): string {
    if (this.currentRoute.startsWith('/user-management')) {
      return 'User administration';
    }

    if (this.currentRoute.startsWith('/password-management')) {
      return 'Password communication';
    }

    if (this.currentRoute.startsWith('/employee-directory')) {
      return 'Employee directory';
    }

    if (this.currentRoute.startsWith('/password-message-audit')) {
      return 'Password SMS audit';
    }

    if (this.currentRoute.startsWith('/password-sms-templates')) {
      return 'SMS template administration';
    }

    if (this.currentRoute.startsWith('/change-password')) {
      return 'Password security';
    }

    if (this.currentRoute.startsWith('/telebirr-transfer')) {
      return 'Telebirr agent transfer';
    }

    if (this.currentRoute.startsWith('/resource-mobilization-approvals')) {
      return 'Mobilization approval workspace';
    }

    if (this.currentRoute.startsWith('/resource-mobilization-report')) {
      return this.currentUser?.role === 'SENIOR_MANAGEMENT' || this.currentUser?.role === 'BRANCH_BANKING'
        ? 'System deposit campaign reporting'
        : 'Resource mobilization reporting';
    }

    if (this.currentRoute.startsWith('/resource-mobilization')) {
      return 'Resource mobilization workspace';
    }

    if (this.currentRoute.startsWith('/rental-payment')) {
      return 'Rental payment workspace';
    }

    if (this.currentRoute.startsWith('/rental-approvals')) {
      return 'Rental approval workspace';
    }

    if (this.currentRoute.startsWith('/onboarding-report')) {
      return this.currentUser?.role === 'KYC_UNIT'
        ? 'KYC review reporting'
        : 'Onboarding reporting';
    }

    if (this.currentRoute.startsWith('/telebirr-approvals')) {
      return 'Telebirr approval workspace';
    }

    if (this.currentRoute.startsWith('/telebirr-report')) {
      return 'Telebirr transfer reporting';
    }

    if (this.currentRoute.startsWith('/workspace')) {
      return 'Branch operations workspace';
    }

    return this.currentUser?.role === 'CHECKER'
      ? 'Checker approval workspace'
      : this.currentUser?.role === 'RENTAL_CHECKER'
        ? 'Rental checker workspace'
      : 'Customer account opening';
  }

  get shellCopy(): string {
    if (this.currentRoute.startsWith('/user-management')) {
      return 'Manage users, branch assignment, roles, account status, and password resets.';
    }

    if (this.currentRoute.startsWith('/password-management')) {
      return 'Search employees and send credential SMS.';
    }

    if (this.currentRoute.startsWith('/employee-directory')) {
      return 'Search, update, and maintain employee records.';
    }

    if (this.currentRoute.startsWith('/password-message-audit')) {
      return 'Review password reset and new-user SMS activity.';
    }

    if (this.currentRoute.startsWith('/password-sms-templates')) {
      return 'Maintain the SMS wording used for password reset and new user credential notifications.';
    }

    if (this.currentRoute.startsWith('/change-password')) {
      return 'Change your password any time to keep your account secure.';
    }

    if (this.currentRoute.startsWith('/telebirr-transfer')) {
      return 'Verify the customer account, confirm the agent, and send the transfer for review.';
    }

    if (this.currentRoute.startsWith('/resource-mobilization-approvals')) {
      return 'Review mobilization submissions from your branch and approve only the verified campaign entries.';
    }

    if (this.currentRoute.startsWith('/resource-mobilization-report')) {
      return this.currentUser?.role === 'SENIOR_MANAGEMENT' || this.currentUser?.role === 'BRANCH_BANKING'
        ? 'View the full system dashboard and detailed campaign register.'
        : 'Track campaign activity and review the reporting register.';
    }

    if (this.currentRoute.startsWith('/resource-mobilization')) {
      return 'Validate the transaction and submit the mobilization record.';
    }

    if (this.currentRoute.startsWith('/rental-payment')) {
      return 'Fetch pending rental bills, prepare the payment routing, and submit the request for rental checker approval.';
    }

    if (this.currentRoute.startsWith('/rental-approvals')) {
      return 'Review submitted rental payment requests for your branch and post them to CBS only after approval.';
    }

    if (this.currentRoute.startsWith('/onboarding-report')) {
      return this.currentUser?.role === 'KYC_UNIT'
        ? 'Review account-created onboarding records, mark KYC completion, and monitor branch readiness from one place.'
        : 'Track onboarding requests, created accounts, KYC progress, and branch totals from one report workspace.';
    }

    if (this.currentRoute.startsWith('/telebirr-approvals')) {
      return 'Review pending transfer requests for your branch and complete the approval step.';
    }

    if (this.currentRoute.startsWith('/telebirr-report')) {
      return 'View branch transfer history, references, statuses, and result details in one report.';
    }

    if (this.currentRoute.startsWith('/workspace')) {
      return 'Choose the workstream you want to open.';
    }

    return this.currentUser?.role === 'CHECKER'
      ? 'Review branch requests and approve ready cases.'
      : this.currentUser?.role === 'RENTAL_CHECKER'
        ? 'Review rental requests and approve only validated postings.'
      : 'Verify the customer, complete the form, and submit the request.';
  }

  get isOnboardingRoute(): boolean {
    return ['/fan-verification', '/customer-details', '/review-submit', '/account-creation']
      .some((route) => this.currentRoute.startsWith(route));
  }

  logout(): void {
    this.auth.logout();
    this.clearInactivityTimer();
    this.router.navigate(['/login']);
  }

  private setupInactivityTracking(shouldTrack: boolean): void {
    if (!shouldTrack) {
      this.clearInactivityTimer();
      this.activitySubscription?.unsubscribe();
      this.activitySubscription = null;
      return;
    }

    if (!this.activitySubscription) {
      this.activitySubscription = merge(
        fromEvent(document, 'mousemove'),
        fromEvent(document, 'mousedown'),
        fromEvent(document, 'keydown'),
        fromEvent(document, 'scroll'),
        fromEvent(document, 'touchstart')
      ).subscribe(() => this.resetInactivityTimer());
    }

    this.resetInactivityTimer();
  }

  private resetInactivityTimer(): void {
    this.clearInactivityTimer();
    this.inactivityTimer = setTimeout(() => {
      if (!this.auth.isAuthenticated()) {
        return;
      }

      this.auth.logout();
      this.toast.info('Session expired', 'You were logged out after inactivity.');
      this.router.navigate(['/login']);
    }, this.inactivityTimeoutMs);
  }

  private clearInactivityTimer(): void {
    if (this.inactivityTimer) {
      clearTimeout(this.inactivityTimer);
      this.inactivityTimer = null;
    }
  }
}
