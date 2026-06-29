export interface ServiceCard {
  icon: 'banking' | 'integration' | 'leadership';
  title: string;
  description: string;
  outcomes: string[];
}

export interface CaseStudyCard {
  icon: 'identity' | 'payments' | 'platform';
  client: string;
  title: string;
  summary: string;
  metrics: string[];
}

export interface StatItem {
  value: string;
  label: string;
  description: string;
}

export interface ContactRequest {
  name: string;
  email: string;
  company: string;
  projectType: string;
  budget: string;
  details: string;
}
