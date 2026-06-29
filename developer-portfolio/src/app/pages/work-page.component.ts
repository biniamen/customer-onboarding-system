import { ChangeDetectionStrategy, Component } from '@angular/core';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-work-page',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './work-page.component.html',
  styleUrls: ['./shared-page.scss'],
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class WorkPageComponent {
  readonly engagements = [
    {
      title: 'Share Management System and automated voting platform',
      outcome: 'Built a comprehensive shareholder management solution with attendance tracking and automated voting capabilities.',
      detail: 'Designed the system for structured participation, verifiable decision flow, and dependable operational execution in enterprise contexts.'
    },
    {
      title: 'Fayda-integrated verification, onboarding, and harmonization solutions',
      outcome: 'Delivered identity-aware onboarding and profile verification portals for branch and online customers using Fayda-integrated workflows.',
      detail: 'The result was a more reliable customer onboarding process aligned with compliance, customer experience, and operational efficiency.'
    },
    {
      title: 'Enterprise middleware and connected banking ecosystem',
      outcome: 'Built integration layers connecting core banking systems with Telebirr, Airtime, Kacha, Guzo Go, and M-Pesa.',
      detail: 'This strengthened interoperability, reduced manual friction, and enabled more scalable enterprise service delivery.'
    },
    {
      title: 'Operational banking systems and transformation programs',
      outcome: 'Contributed to Bulk Salary Payment, End-of-Day Monitoring, Smart Branch, VTM, OBDX upgrades, AI onboarding, IPS, and QR initiatives.',
      detail: 'These programs combined engineering execution, stakeholder management, and transformation leadership to improve control, speed, and service quality.'
    }
  ];
}
