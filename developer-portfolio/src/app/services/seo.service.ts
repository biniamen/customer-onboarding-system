import { Injectable } from '@angular/core';
import { Meta, Title } from '@angular/platform-browser';

import { environment } from '../../environments/environment';

@Injectable({ providedIn: 'root' })
export class SeoService {
  constructor(
    private readonly title: Title,
    private readonly meta: Meta
  ) {}

  updateSeo(config: { title: string; description: string; keywords: string; path: string }): void {
    const pageTitle = `${config.title} | Biniyam K.`;
    const canonicalUrl = `${environment.siteUrl}${config.path === '/' ? '' : config.path}`;

    this.title.setTitle(pageTitle);
    this.meta.updateTag({ name: 'description', content: config.description });
    this.meta.updateTag({ name: 'keywords', content: config.keywords });
    this.meta.updateTag({ name: 'robots', content: 'index, follow' });
    this.meta.updateTag({ property: 'og:title', content: pageTitle });
    this.meta.updateTag({ property: 'og:description', content: config.description });
    this.meta.updateTag({ property: 'og:type', content: 'website' });
    this.meta.updateTag({ property: 'og:url', content: canonicalUrl });
    this.meta.updateTag({ property: 'og:site_name', content: 'Biniyam K.' });
    this.meta.updateTag({ name: 'twitter:card', content: 'summary_large_image' });
    this.meta.updateTag({ name: 'twitter:title', content: pageTitle });
    this.meta.updateTag({ name: 'twitter:description', content: config.description });
  }
}
