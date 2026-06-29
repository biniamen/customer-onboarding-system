import { ChangeDetectionStrategy, Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';

@Component({
  selector: 'app-services-page',
  standalone: true,
  imports: [CommonModule, RouterModule],
  templateUrl: './services-page.component.html',
  styleUrls: ['./shared-page.scss'],
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class ServicesPageComponent {
  readonly services = [
    {
      title: 'Core banking integration and enterprise architecture',
      description: 'Design and delivery for Flexcube-connected solutions, transaction processing, middleware, enterprise APIs, and large-scale integration across banking ecosystems.'
    },
    {
      title: 'Digital onboarding, Fayda, and compliance-driven platforms',
      description: 'Secure onboarding, harmonization, verification, DMS, and workflow platforms that balance compliance needs with operational efficiency and customer experience.'
    },
    {
      title: 'Payment systems and connected digital services',
      description: 'Solution delivery for salary systems, payment integrations, IPS, QR, and connected service ecosystems including Telebirr, M-Pesa, Airtime, Kacha, and Guzo Go.'
    },
    {
      title: 'Transformation leadership and enterprise delivery',
      description: 'Project and technical leadership for Smart Branch, VTM, OBDX upgrades, AI-powered onboarding, and high-impact enterprise modernization programs.'
    }
  ];
}
