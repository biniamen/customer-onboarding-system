import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable, of } from 'rxjs';

import { environment } from '../../environments/environment';
import { ContactRequest } from '../models/portfolio.models';

@Injectable({ providedIn: 'root' })
export class ContactService {
  private readonly emailJsUrl = 'https://api.emailjs.com/api/v1.0/email/send';

  constructor(private readonly http: HttpClient) {}

  submitInquiry(payload: ContactRequest): Observable<unknown> {
    const { serviceId, templateId, publicKey } = environment.emailjs;

    if (!serviceId || !templateId || !publicKey) {
      return of({
        fallback: true
      });
    }

    return this.http.post(
      this.emailJsUrl,
      {
        service_id: serviceId,
        template_id: templateId,
        user_id: publicKey,
        template_params: {
          from_name: payload.name,
          from_email: payload.email,
          company: payload.company,
          project_type: payload.projectType,
          budget: payload.budget,
          message: payload.details,
          reply_to: payload.email,
          to_email: 'biniyamkm@gmail.com'
        }
      },
      {
        responseType: 'text'
      }
    );
  }
}
