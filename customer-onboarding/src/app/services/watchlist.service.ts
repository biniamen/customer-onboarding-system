import { HttpClient, HttpParams } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { environment } from 'src/environments/environment';
import {
  UpsertWatchlistEntryRequest,
  WatchlistEntry,
  WatchlistImportResult,
  WatchlistPagedResponse,
  WatchlistQuery
} from '../models/onboarding.models';

@Injectable({ providedIn: 'root' })
export class WatchlistService {
  private readonly baseUrl = `${environment.api.coreBaseUrl}/watchlist`;

  constructor(private http: HttpClient) {}

  getPaged(query: WatchlistQuery): Observable<WatchlistPagedResponse> {
    let params = new HttpParams();
    Object.entries(query || {}).forEach(([key, value]) => {
      if (value !== null && value !== undefined && value !== '') {
        params = params.set(key, String(value));
      }
    });

    return this.http.get<WatchlistPagedResponse>(this.baseUrl, { params });
  }

  create(payload: UpsertWatchlistEntryRequest): Observable<WatchlistEntry> {
    return this.http.post<WatchlistEntry>(this.baseUrl, payload);
  }

  update(id: string, payload: UpsertWatchlistEntryRequest): Observable<WatchlistEntry> {
    return this.http.put<WatchlistEntry>(`${this.baseUrl}/${id}`, payload);
  }

  remove(id: string): Observable<void> {
    return this.http.delete<void>(`${this.baseUrl}/${id}`);
  }

  importWorkbook(file: File): Observable<WatchlistImportResult> {
    const formData = new FormData();
    formData.append('file', file, file.name);
    return this.http.post<WatchlistImportResult>(`${this.baseUrl}/import`, formData);
  }

  downloadTemplate(): Observable<Blob> {
    return this.http.get(`${this.baseUrl}/import-template`, { responseType: 'blob' });
  }
}
