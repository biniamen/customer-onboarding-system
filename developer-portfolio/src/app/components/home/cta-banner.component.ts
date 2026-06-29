import { CommonModule } from '@angular/common';
import { ChangeDetectionStrategy, Component } from '@angular/core';
import { RouterModule } from '@angular/router';

@Component({
  selector: 'app-cta-banner',
  standalone: true,
  imports: [CommonModule, RouterModule],
  templateUrl: './cta-banner.component.html',
  styleUrls: ['./cta-banner.component.scss'],
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class CtaBannerComponent {}
