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

  constructor(private auth: AuthService) {}

  get isMaker(): boolean {
    return this.auth.getCurrentUser()?.role === 'MAKER';
  }

  get isChecker(): boolean {
    return this.auth.getCurrentUser()?.role === 'CHECKER';
  }

  get isReportViewer(): boolean {
    return this.auth.getCurrentUser()?.role === 'REPORT_VIEWER';
  }

  get isKycUnit(): boolean {
    return this.auth.getCurrentUser()?.role === 'KYC_UNIT';
  }

  get isAdmin(): boolean {
    return this.auth.getCurrentUser()?.role === 'ADMIN';
  }
}
