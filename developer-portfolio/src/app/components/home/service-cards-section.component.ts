import { CommonModule } from '@angular/common';
import { ChangeDetectionStrategy, Component, Input } from '@angular/core';

import { ServiceCard } from '../../models/portfolio.models';

@Component({
  selector: 'app-service-cards-section',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './service-cards-section.component.html',
  styleUrls: ['./service-cards-section.component.scss'],
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class ServiceCardsSectionComponent {
  @Input() services: ServiceCard[] = [];
}
