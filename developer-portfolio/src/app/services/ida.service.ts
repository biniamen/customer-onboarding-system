import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { environment } from 'src/environments/environment';
import { IdaEkycRequest, IdaOtpRequest, IdaOtpResponse } from '../models/onboarding.models';

@Injectable({
  providedIn: 'root'
})
export class IdaService {
  private readonly baseUrl = environment.api.idaBaseUrl;

  constructor(private http: HttpClient) {}

  sendFanOtp(fan: string): Observable<IdaOtpResponse> {
    const body: IdaOtpRequest = {
      individualId: fan,
      individualIdType: 'FAN',
      otpChannel: ['email', 'phone']
    };

    return this.http.post<IdaOtpResponse>(`${this.baseUrl}/otp`, body);
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
