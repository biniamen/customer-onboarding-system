import { ChangeDetectionStrategy, Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';

@Component({
  selector: 'app-about-page',
  standalone: true,
  imports: [CommonModule, RouterModule],
  templateUrl: './about-page.component.html',
  styleUrls: ['./shared-page.scss'],
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class AboutPageComponent {
  readonly principles = [
    'Strong engineering expertise with the ability to lead from architecture through delivery.',
    'Real banking and financial systems experience, not just general software consulting.',
    'Enterprise integration capability spanning core systems, middleware, and digital channels.',
    'Leadership for transformation programs where business priorities and technical execution must stay aligned.'
  ];

  readonly highlights = [
    'BSc in Computer Science with a Master degree specializing in Data Science.',
    '10+ years across software engineering, enterprise systems, and transformation delivery.',
    '7+ years of deep involvement in core banking and financial services environments.',
    'Experience combining technical depth, stakeholder leadership, security awareness, and business understanding.'
  ];
}
