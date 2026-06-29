import { ChangeDetectionStrategy, Component } from '@angular/core';
import { CommonModule } from '@angular/common';

import { CaseStudyCardsSectionComponent } from '../components/home/case-study-cards-section.component';
import { CtaBannerComponent } from '../components/home/cta-banner.component';
import { HeroSectionComponent } from '../components/home/hero-section.component';
import { ServiceCardsSectionComponent } from '../components/home/service-cards-section.component';
import { StatsSectionComponent } from '../components/home/stats-section.component';
import { CaseStudyCard, ServiceCard, StatItem } from '../models/portfolio.models';

@Component({
  selector: 'app-home-page',
  standalone: true,
  imports: [
    CommonModule,
    HeroSectionComponent,
    ServiceCardsSectionComponent,
    CaseStudyCardsSectionComponent,
    StatsSectionComponent,
    CtaBannerComponent
  ],
  template: `
    <app-hero-section></app-hero-section>
    <app-service-cards-section [services]="services"></app-service-cards-section>
    <app-case-study-cards-section [caseStudies]="caseStudies"></app-case-study-cards-section>
    <app-stats-section [stats]="stats"></app-stats-section>
    <app-cta-banner></app-cta-banner>
  `,
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class HomePageComponent {
  readonly services: ServiceCard[] = [
    {
      icon: 'banking',
      title: 'Business workflow automation',
      description: 'I design and build internal systems, approval workflows, portals, and operational tools that help organizations reduce manual work and move faster.',
      outcomes: ['Custom workflow systems', 'Operational dashboards and portals', 'Automation for manual processes']
    },
    {
      icon: 'integration',
      title: 'Software products and enterprise integration',
      description: 'From web applications to enterprise middleware, I create reliable systems that connect data, teams, and third-party services in a practical way.',
      outcomes: ['Modern web application delivery', 'API and middleware integration', 'Scalable enterprise system design']
    },
    {
      icon: 'leadership',
      title: 'Fintech, banking, and transformation leadership',
      description: 'My banking and fintech experience gives me an extra edge for regulated, high-trust systems, while still being valuable for any organization building serious digital products.',
      outcomes: ['Digital onboarding and fintech solutions', 'Transformation program delivery', 'Leadership from architecture to release']
    }
  ];

  readonly caseStudies: CaseStudyCard[] = [
    {
      icon: 'identity',
      client: 'Identity, onboarding, and customer operations',
      title: 'Built onboarding and verification platforms that improve trust, speed, and control',
      summary: 'Delivered digital onboarding, verification, and harmonization systems that improved customer flow and reduced process friction.',
      metrics: ['Customer onboarding platforms', 'Verification workflows', 'Operational efficiency']
    },
    {
      icon: 'payments',
      client: 'Payments, services, and ecosystem connectivity',
      title: 'Delivered transaction and service integrations that connected platforms with the real business world',
      summary: 'Built systems that integrated payments, salaries, external services, and core enterprise workflows into dependable operational platforms.',
      metrics: ['Payment and service integrations', 'Connected operational systems', 'Reliable digital transactions']
    },
    {
      icon: 'platform',
      client: 'Enterprise systems and automation',
      title: 'Architected internal platforms, monitoring systems, and workflow tools that support daily execution',
      summary: 'Created operational systems spanning document management, monitoring, shareholder services, and process automation for enterprise use cases.',
      metrics: ['Internal platforms', 'Monitoring and reporting', 'Automation-driven operations']
    }
  ];

  readonly stats: StatItem[] = [
    {
      value: '10+',
      label: 'Years in software engineering and enterprise solution delivery',
      description: 'Long-term experience across full-stack development, architecture, modernization, and large-scale program execution.'
    },
    {
      value: '7+',
      label: 'Years focused on banking and financial systems',
      description: 'Deep domain exposure across core banking, compliance workflows, payment ecosystems, and operational banking platforms.'
    },
    {
      value: '12+',
      label: 'Core technologies and enterprise platforms used with confidence',
      description: 'C#, Java Spring Boot, Python, PHP, Angular, TypeScript, Oracle, PostgreSQL, MySQL, SQL Server, Flexcube, and integration stacks.'
    }
  ];
}
