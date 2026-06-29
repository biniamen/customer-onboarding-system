import { CommonModule } from '@angular/common';
import { ChangeDetectionStrategy, Component, Input } from '@angular/core';

import { StatItem } from '../../models/portfolio.models';

@Component({
  selector: 'app-stats-section',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './stats-section.component.html',
  styleUrls: ['./stats-section.component.scss'],
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class StatsSectionComponent {
  @Input() stats: StatItem[] = [];
}
