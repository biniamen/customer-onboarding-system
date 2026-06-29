import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { catchError } from 'rxjs/operators';
import { throwError } from 'rxjs';
import { environment } from 'src/environments/environment';
import { IdaEkycRequest, IdaOtpRequest, IdaOtpResponse } from '../models/onboarding.models';

@Injectable({
  providedIn: 'root'
})
export class IdaService {
  private readonly baseUrl = environment.api.idaBaseUrl;

  constructor(private http: HttpClient) {}

  sendFanOtp(fan: string): Observable<IdaOtpResponse> {
    const preferredChannels: IdaOtpRequest = {
      individualId: fan,
      individualIdType: 'FAN',
      otpChannel: ['email', 'phone']
    };

    const phoneOnlyChannels: IdaOtpRequest = {
      individualId: fan,
      individualIdType: 'FAN',
      otpChannel: ['phone']
    };

    return this.http.post<IdaOtpResponse>(`${this.baseUrl}/otp`, preferredChannels).pipe(
      catchError((error: any) => {
        const shouldRetryWithPhoneOnly =
          error?.status >= 500 ||
          error?.status === 0 ||
          (typeof error?.error === 'string' && error.error.toLowerCase().includes('internal server error'));

        if (!shouldRetryWithPhoneOnly) {
          return throwError(() => error);
        }

        return this.http.post<IdaOtpResponse>(`${this.baseUrl}/otp`, phoneOnlyChannels);
      })
    );
  }

  verifyFanOtp(fan: string, otp: string, transactionId: string): Observable<any> {
    const body: IdaEkycRequest = {
      individualId: fan,
      individualIdType: 'FAN',
      otp,
      transactionId
    };

    return this.http.post<any>(`${this.baseUrl}/ekyc`, body);
  }
}
