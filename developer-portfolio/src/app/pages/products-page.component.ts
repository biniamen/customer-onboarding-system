import { ChangeDetectionStrategy, Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';

@Component({
  selector: 'app-products-page',
  standalone: true,
  imports: [CommonModule, RouterModule],
  templateUrl: './products-page.component.html',
  styleUrls: ['./shared-page.scss'],
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class ProductsPageComponent {
  readonly products = [
    {
      name: 'Fayda onboarding and harmonization blueprint',
      description: 'A reusable architecture and workflow approach for secure customer onboarding, verification, and profile harmonization across branch and digital channels.'
    },
    {
      name: 'Enterprise middleware integration framework',
      description: 'A practical framework for connecting core banking systems with payment services, middleware layers, and external enterprise platforms without creating brittle delivery dependencies.'
    },
    {
      name: 'Smart Branch and digital transformation playbook',
      description: 'A structured delivery model for Smart Branch, VTM, OBDX, AI onboarding, and enterprise modernization programs that require technical and operational alignment.'
    }
  ];
}
