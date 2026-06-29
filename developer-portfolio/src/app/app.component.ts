import { CommonModule } from '@angular/common';
import { ChangeDetectionStrategy, Component } from '@angular/core';
import { ActivatedRoute, Data, NavigationEnd, Router, RouterModule } from '@angular/router';
import { filter } from 'rxjs';

import { SeoService } from './services/seo.service';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [CommonModule, RouterModule],
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss'],
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class AppComponent {
  readonly navigation = [
    { label: 'Home', path: '/' },
    { label: 'About', path: '/about' },
    { label: 'Services', path: '/services' },
    { label: 'Work', path: '/work' },
    { label: 'Products', path: '/products' },
    { label: 'Contact', path: '/contact' }
  ];

  mobileMenuOpen = false;

  constructor(
    private readonly router: Router,
    private readonly activatedRoute: ActivatedRoute,
    private readonly seoService: SeoService
  ) {
    this.applySeo(this.router.url || '/');

    this.router.events
      .pipe(filter((event): event is NavigationEnd => event instanceof NavigationEnd))
      .subscribe((event) => {
        this.mobileMenuOpen = false;
        this.applySeo(event.urlAfterRedirects);
      });
  }

  toggleMobileMenu(): void {
    this.mobileMenuOpen = !this.mobileMenuOpen;
  }

  private applySeo(path: string): void {
    let route = this.activatedRoute;

    while (route.firstChild) {
      route = route.firstChild;
    }

    const data = route.snapshot.data as Data & {
      description?: string;
      keywords?: string;
    };

    this.seoService.updateSeo({
      title: route.snapshot.title ?? 'Software Engineer, Technology Leader, and Banking Transformation Specialist',
      description: data.description ?? 'Secure, scalable, and business-focused digital solutions for banking and enterprise environments.',
      keywords: data.keywords ?? 'banking software engineer, enterprise architect, digital transformation specialist',
      path
    });
  }
}
