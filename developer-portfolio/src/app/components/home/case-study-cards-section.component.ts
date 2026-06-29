import { CommonModule } from '@angular/common';
import { ChangeDetectionStrategy, Component, Input } from '@angular/core';
import { RouterModule } from '@angular/router';

import { CaseStudyCard } from '../../models/portfolio.models';

@Component({
  selector: 'app-case-study-cards-section',
  standalone: true,
  imports: [CommonModule, RouterModule],
  templateUrl: './case-study-cards-section.component.html',
  styleUrls: ['./case-study-cards-section.component.scss'],
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class CaseStudyCardsSectionComponent {
  @Input() caseStudies: CaseStudyCard[] = [];
}
