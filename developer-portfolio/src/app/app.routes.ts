import { Routes } from '@angular/router';

import { AboutPageComponent } from './pages/about-page.component';
import { ContactPageComponent } from './pages/contact-page.component';
import { HomePageComponent } from './pages/home-page.component';
import { ProductsPageComponent } from './pages/products-page.component';
import { ServicesPageComponent } from './pages/services-page.component';
import { WorkPageComponent } from './pages/work-page.component';

export interface SeoRouteData {
  description: string;
  keywords: string;
}

export const routes: Routes = [
  {
    path: '',
    component: HomePageComponent,
    title: 'Software Engineer, Automation Specialist, and Technology Leader',
    data: {
      description: 'Biniyam K. helps organizations build software products, automate workflows, connect systems, and deliver secure digital platforms with enterprise-grade reliability.',
      keywords: 'software engineer, workflow automation, digital transformation specialist, freelance developer, enterprise architect'
    } as SeoRouteData
  },
  {
    path: 'about',
    component: AboutPageComponent,
    title: 'About | Banking Domain Expertise with Deep Technical Leadership',
    data: {
      description: 'Learn how Biniyam K. combines 10+ years of software engineering, architecture, automation, and digital transformation delivery into measurable business outcomes.',
      keywords: 'technology leader profile, software engineer portfolio, workflow automation expert, digital transformation leader'
    } as SeoRouteData
  },
  {
    path: 'services',
    component: ServicesPageComponent,
    title: 'Services | Core Banking Integration, Digital Platforms, and Transformation Delivery',
    data: {
      description: 'Explore services spanning workflow automation, custom software, enterprise integration, digital platforms, fintech systems, and transformation leadership.',
      keywords: 'workflow automation services, custom software developer, enterprise integration, freelance technology consultant, digital transformation'
    } as SeoRouteData
  },
  {
    path: 'work',
    component: WorkPageComponent,
    title: 'Work | Banking Systems, Middleware, and Digital Transformation Delivery',
    data: {
      description: 'Review selected work across automation, enterprise systems, onboarding platforms, integrations, payments, and operational software delivery.',
      keywords: 'software portfolio, workflow automation case study, enterprise systems delivery, integration projects, digital product delivery'
    } as SeoRouteData
  },
  {
    path: 'products',
    component: ProductsPageComponent,
    title: 'Products | Banking Delivery Accelerators and Architecture Frameworks',
    data: {
      description: 'Discover reusable frameworks and accelerators for onboarding, enterprise integration, workflow automation, and digital transformation delivery.',
      keywords: 'automation framework, enterprise integration toolkit, digital transformation accelerator, software delivery playbook'
    } as SeoRouteData
  },
  {
    path: 'contact',
    component: ContactPageComponent,
    title: 'Contact | Discuss Banking Technology and Transformation Initiatives',
    data: {
      description: 'Get in touch with Biniyam K. to discuss automation, software development, enterprise systems, fintech solutions, or digital transformation work.',
      keywords: 'hire freelance developer, workflow automation consultant, software architect contact, digital transformation contact'
    } as SeoRouteData
  },
  {
    path: '**',
    redirectTo: ''
  }
];
