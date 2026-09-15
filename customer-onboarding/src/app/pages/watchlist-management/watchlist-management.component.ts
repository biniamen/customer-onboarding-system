import { Component, OnInit } from '@angular/core';
import { FormBuilder, Validators } from '@angular/forms';
import { firstValueFrom } from 'rxjs';
import {
  UpsertWatchlistEntryRequest,
  WatchlistEntry,
  WatchlistImportResult
} from 'src/app/models/onboarding.models';
import { ToastService } from 'src/app/services/toast.service';
import { WatchlistService } from 'src/app/services/watchlist.service';

@Component({
  selector: 'app-watchlist-management',
  templateUrl: './watchlist-management.component.html',
  styleUrls: ['./watchlist-management.component.css']
})
export class WatchlistManagementComponent implements OnInit {
  readonly pageSizeOptions = [10, 20, 50, 100];
  readonly categoryOptions = [
    { value: '', label: 'All categories' },
    { value: 'PEP', label: 'PEP' },
    { value: 'SANCTION', label: 'Sanction' },
    { value: 'WATCHLIST', label: 'Watchlist' },
    { value: 'NBE_RESTRICTED', label: 'NBE restricted' },
    { value: 'INTERNAL_BLACKLIST', label: 'Internal blacklist' }
  ];
  readonly activeOptions = [
    { value: '', label: 'All statuses' },
    { value: 'true', label: 'Active only' },
    { value: 'false', label: 'Inactive only' }
  ];

  loading = false;
  importing = false;
  saving = false;
  deleting = false;
  exporting = false;
  pageError: string | null = null;
  importMessage: string | null = null;
  importErrors: string[] = [];

  entries: WatchlistEntry[] = [];
  selectedEntry: WatchlistEntry | null = null;
  selectedFile: File | null = null;
  isCreating = false;

  searchTerm = '';
  categoryFilter = '';
  activeFilter = 'true';
  pageSize = 20;
  currentPage = 1;
  totalPages = 1;
  totalRecords = 0;
  activeRecords = 0;
  pepRecords = 0;
  sanctionRecords = 0;

  entryForm = this.fb.group({
    fullName: ['', [Validators.required, Validators.maxLength(240)]],
    alternateNames: ['', [Validators.maxLength(1000)]],
    screeningCategory: ['PEP', [Validators.required]],
    sourceList: ['', [Validators.required, Validators.maxLength(160)]],
    sourceReference: ['', [Validators.maxLength(160)]],
    riskLevel: ['', [Validators.maxLength(40)]],
    nationality: ['', [Validators.maxLength(120)]],
    dateOfBirth: [''],
    placeOfBirth: ['', [Validators.maxLength(160)]],
    documentType: ['', [Validators.maxLength(100)]],
    documentNumber: ['', [Validators.maxLength(160)]],
    positionOrRole: ['', [Validators.maxLength(240)]],
    organization: ['', [Validators.maxLength(240)]],
    country: ['', [Validators.maxLength(120)]],
    cityOrRegion: ['', [Validators.maxLength(160)]],
    address: ['', [Validators.maxLength(1000)]],
    listedOn: [''],
    expiryDate: [''],
    isActive: [true],
    isPep: [true],
    isSanctioned: [false],
    requiresEnhancedDueDiligence: [false],
    remarks: ['', [Validators.maxLength(2000)]],
    sourceUrl: ['', [Validators.maxLength(500)]]
  });

  constructor(
    private fb: FormBuilder,
    private watchlist: WatchlistService,
    private toast: ToastService
  ) {}

  ngOnInit(): void {
    this.loadEntries();
  }

  loadEntries(): void {
    this.loading = true;
    this.pageError = null;

    this.watchlist.getPaged(this.buildQuery(this.currentPage, this.pageSize)).subscribe({
      next: (response) => {
        this.loading = false;
        this.entries = response.items || [];
        this.currentPage = response.page || 1;
        this.totalPages = response.totalPages || 1;
        this.totalRecords = response.totalRecords || 0;
        this.activeRecords = response.activeRecords || 0;
        this.pepRecords = response.pepRecords || 0;
        this.sanctionRecords = response.sanctionRecords || 0;

        if (this.selectedEntry) {
          const latest = this.entries.find((entry) => entry.id === this.selectedEntry?.id);
          if (latest) {
            this.selectEntry(latest);
          }
        }
      },
      error: (error: any) => {
        this.loading = false;
        this.pageError = this.readError(error, 'Unable to load watchlist entries.');
      }
    });
  }

  applyFilters(): void {
    this.currentPage = 1;
    this.loadEntries();
  }

  resetFilters(): void {
    this.searchTerm = '';
    this.categoryFilter = '';
    this.activeFilter = 'true';
    this.pageSize = 20;
    this.currentPage = 1;
    this.loadEntries();
  }

  changePage(page: number): void {
    if (page < 1 || page > this.totalPages || page === this.currentPage) {
      return;
    }

    this.currentPage = page;
    this.loadEntries();
  }

  updatePageSize(value: number | string): void {
    this.pageSize = Number(value) || 20;
    this.currentPage = 1;
    this.loadEntries();
  }

  get pageNumbers(): number[] {
    const start = Math.max(1, this.currentPage - 2);
    const end = Math.min(this.totalPages, start + 4);
    const normalizedStart = Math.max(1, end - 4);
    return Array.from({ length: end - normalizedStart + 1 }, (_, index) => normalizedStart + index);
  }

  get showingFrom(): number {
    return this.totalRecords ? ((this.currentPage - 1) * this.pageSize) + 1 : 0;
  }

  get showingTo(): number {
    return Math.min(this.currentPage * this.pageSize, this.totalRecords);
  }

  onFileSelected(event: Event): void {
    const input = event.target as HTMLInputElement;
    const file = input.files?.item(0) || null;
    this.importMessage = null;
    this.importErrors = [];
    this.selectedFile = file;
  }

  uploadWorkbook(): void {
    if (!this.selectedFile || this.importing) {
      this.toast.error('Select a workbook', 'Choose the completed .xlsx or .xlsm template first.');
      return;
    }

    this.importing = true;
    this.importMessage = null;
    this.importErrors = [];
    this.watchlist.importWorkbook(this.selectedFile).subscribe({
      next: (result: WatchlistImportResult) => {
        this.importing = false;
        this.importMessage = `${result.insertedRows} added and ${result.updatedRows} updated from ${result.worksheetName}.`;
        this.selectedFile = null;
        this.currentPage = 1;
        this.loadEntries();
        this.toast.success('Watchlist imported', this.importMessage);
      },
      error: (error: any) => {
        this.importing = false;
        this.importErrors = error?.error?.result?.errors || [];
        this.importMessage = this.readError(error, 'The workbook could not be imported.');
        this.toast.error('Import failed', this.importMessage);
      }
    });
  }

  downloadTemplate(): void {
    this.watchlist.downloadTemplate().subscribe({
      next: (file) => {
        const url = URL.createObjectURL(file);
        const anchor = document.createElement('a');
        anchor.href = url;
        anchor.download = 'watchlist-import-template.xlsx';
        anchor.click();
        URL.revokeObjectURL(url);
      },
      error: (error: any) => this.toast.error('Download failed', this.readError(error, 'Unable to download the import template.'))
    });
  }

  async exportPdf(): Promise<void> {
    if (this.exporting) {
      return;
    }

    this.exporting = true;
    try {
      const firstPage = await firstValueFrom(this.watchlist.getPaged(this.buildQuery(1, 250)));
      const exportEntries = [...(firstPage.items || [])];

      for (let page = 2; page <= firstPage.totalPages; page += 1) {
        const response = await firstValueFrom(this.watchlist.getPaged(this.buildQuery(page, 250)));
        exportEntries.push(...(response.items || []));
      }

      const popup = window.open('', '_blank', 'width=1400,height=900');
      if (!popup) {
        this.toast.error('Popup blocked', 'Allow popups to export the Watchlist PDF.');
        return;
      }

      const rows = exportEntries.map((entry, index) => `
        <tr>
          <td>${index + 1}</td>
          <td><strong>${this.escapeHtml(entry.fullName)}</strong><br/><span>${this.escapeHtml(entry.alternateNames || entry.documentNumber || '-')}</span></td>
          <td>${this.escapeHtml(entry.screeningCategory)}</td>
          <td>${this.escapeHtml(entry.sourceList)}<br/><span>${this.escapeHtml(entry.sourceReference || '-')}</span></td>
          <td>${this.escapeHtml(entry.riskLevel || '-')}</td>
          <td>${this.escapeHtml(this.formatFlags(entry))}</td>
          <td>${entry.isActive ? 'Active' : 'Inactive'}</td>
          <td>${this.escapeHtml(this.formatDate(entry.updatedAtUtc))}</td>
        </tr>
      `).join('');

      popup.document.open();
      popup.document.write(`
        <!doctype html>
        <html>
          <head>
            <meta charset="utf-8" />
            <title>Watchlist Screening Register</title>
            <style>
              @page { size: landscape; margin: 12mm; }
              body { color: #172033; font-family: Arial, sans-serif; }
              .heading { border-bottom: 4px solid #eab308; color: #064e2b; padding-bottom: 12px; text-align: center; }
              .heading p, .heading h1, .heading span { margin: 0; }
              .heading p { font-size: 11px; font-weight: 800; letter-spacing: 1.6px; }
              .heading h1 { font-family: Georgia, 'Times New Roman', serif; font-size: 23px; margin-top: 5px; }
              .heading span { color: #475569; display: inline-block; font-size: 10px; font-weight: 700; margin-top: 8px; }
              table { border-collapse: collapse; margin-top: 18px; width: 100%; }
              th, td { border: 1px solid #94a3b8; font-size: 9px; padding: 6px; vertical-align: top; }
              th { background: #edf4ee; color: #064e2b; font-size: 9px; text-align: left; }
              td span { color: #64748b; font-size: 8px; }
              .footer { color: #64748b; font-size: 9px; margin-top: 12px; text-align: right; }
            </style>
          </head>
          <body>
            <div class="heading">
              <p>GLOBAL BANK ETHIOPIA</p>
              <h1>Watchlist Screening Register</h1>
              <span>${this.escapeHtml(this.filterSummary)} | ${exportEntries.length} record${exportEntries.length === 1 ? '' : 's'}</span>
            </div>
            <table>
              <thead><tr><th>#</th><th>Person / Entity</th><th>Category</th><th>Source</th><th>Risk</th><th>Flags</th><th>Status</th><th>Last Updated</th></tr></thead>
              <tbody>${rows || '<tr><td colspan="8">No records match the selected filters.</td></tr>'}</tbody>
            </table>
            <p class="footer">Generated ${this.escapeHtml(new Date().toLocaleString())}</p>
          </body>
        </html>
      `);
      popup.document.close();
      popup.focus();
      popup.print();
      this.toast.success('PDF ready', 'Use the browser print dialog to save the filtered register as PDF.');
    } catch (error: any) {
      this.toast.error('Export failed', this.readError(error, 'Unable to prepare the Watchlist PDF.'));
    } finally {
      this.exporting = false;
    }
  }

  beginCreate(): void {
    this.isCreating = true;
    this.selectedEntry = null;
    this.entryForm.reset({
      screeningCategory: 'PEP',
      isActive: true,
      isPep: true,
      isSanctioned: false,
      requiresEnhancedDueDiligence: false
    });
  }

  selectEntry(entry: WatchlistEntry): void {
    this.isCreating = false;
    this.selectedEntry = entry;
    this.entryForm.patchValue({
      fullName: entry.fullName,
      alternateNames: entry.alternateNames || '',
      screeningCategory: entry.screeningCategory,
      sourceList: entry.sourceList,
      sourceReference: entry.sourceReference || '',
      riskLevel: entry.riskLevel || '',
      nationality: entry.nationality || '',
      dateOfBirth: this.asDateInput(entry.dateOfBirth),
      placeOfBirth: entry.placeOfBirth || '',
      documentType: entry.documentType || '',
      documentNumber: entry.documentNumber || '',
      positionOrRole: entry.positionOrRole || '',
      organization: entry.organization || '',
      country: entry.country || '',
      cityOrRegion: entry.cityOrRegion || '',
      address: entry.address || '',
      listedOn: this.asDateInput(entry.listedOn),
      expiryDate: this.asDateInput(entry.expiryDate),
      isActive: entry.isActive,
      isPep: entry.isPep,
      isSanctioned: entry.isSanctioned,
      requiresEnhancedDueDiligence: entry.requiresEnhancedDueDiligence,
      remarks: entry.remarks || '',
      sourceUrl: entry.sourceUrl || ''
    });
  }

  closeEditor(): void {
    this.isCreating = false;
    this.selectedEntry = null;
    this.entryForm.reset();
  }

  saveEntry(): void {
    this.entryForm.markAllAsTouched();
    if (this.entryForm.invalid || this.saving) {
      return;
    }

    const payload = this.buildPayload();
    this.saving = true;
    const request = this.isCreating
      ? this.watchlist.create(payload)
      : this.watchlist.update(this.selectedEntry!.id, payload);

    request.subscribe({
      next: (entry) => {
        this.saving = false;
        this.toast.success(this.isCreating ? 'Watchlist entry added' : 'Watchlist entry updated', entry.fullName);
        this.isCreating = false;
        this.selectedEntry = entry;
        this.currentPage = 1;
        this.loadEntries();
      },
      error: (error: any) => {
        this.saving = false;
        this.toast.error('Save failed', this.readError(error, 'Unable to save watchlist entry.'));
      }
    });
  }

  deleteEntry(): void {
    if (!this.selectedEntry || this.deleting) {
      return;
    }

    if (!window.confirm(`Delete ${this.selectedEntry.fullName} from the watchlist?`)) {
      return;
    }

    this.deleting = true;
    this.watchlist.remove(this.selectedEntry.id).subscribe({
      next: () => {
        this.deleting = false;
        this.toast.success('Watchlist entry deleted', 'The entry was removed and the action was recorded in the audit log.');
        this.closeEditor();
        this.loadEntries();
      },
      error: (error: any) => {
        this.deleting = false;
        this.toast.error('Delete failed', this.readError(error, 'Unable to delete watchlist entry.'));
      }
    });
  }

  categoryChanged(): void {
    const category = this.entryForm.controls.screeningCategory.value || '';
    if (category === 'PEP') {
      this.entryForm.patchValue({ isPep: true });
    }
    if (category === 'SANCTION') {
      this.entryForm.patchValue({ isSanctioned: true });
    }
  }

  formatFlags(entry: WatchlistEntry): string {
    const flags = [entry.isPep ? 'PEP' : '', entry.isSanctioned ? 'Sanction' : '', entry.requiresEnhancedDueDiligence ? 'EDD' : '']
      .filter(Boolean);
    return flags.join(', ') || '-';
  }

  isHighRisk(entry: WatchlistEntry): boolean {
    return (entry.riskLevel || '').toUpperCase().includes('HIGH');
  }

  formatDate(value: string | null | undefined): string {
    if (!value) {
      return '-';
    }

    const date = new Date(value);
    return Number.isNaN(date.getTime()) ? '-' : date.toLocaleDateString();
  }

  private buildPayload(): UpsertWatchlistEntryRequest {
    const value = this.entryForm.getRawValue();
    return {
      fullName: value.fullName || '',
      alternateNames: this.optional(value.alternateNames),
      screeningCategory: value.screeningCategory || '',
      sourceList: value.sourceList || '',
      sourceReference: this.optional(value.sourceReference),
      riskLevel: this.optional(value.riskLevel),
      nationality: this.optional(value.nationality),
      dateOfBirth: this.optional(value.dateOfBirth),
      placeOfBirth: this.optional(value.placeOfBirth),
      documentType: this.optional(value.documentType),
      documentNumber: this.optional(value.documentNumber),
      positionOrRole: this.optional(value.positionOrRole),
      organization: this.optional(value.organization),
      country: this.optional(value.country),
      cityOrRegion: this.optional(value.cityOrRegion),
      address: this.optional(value.address),
      listedOn: this.optional(value.listedOn),
      expiryDate: this.optional(value.expiryDate),
      isActive: !!value.isActive,
      isPep: !!value.isPep,
      isSanctioned: !!value.isSanctioned,
      requiresEnhancedDueDiligence: !!value.requiresEnhancedDueDiligence,
      remarks: this.optional(value.remarks),
      sourceUrl: this.optional(value.sourceUrl)
    };
  }

  private optional(value: string | null | undefined): string | null {
    const normalized = value?.trim();
    return normalized ? normalized : null;
  }

  private asDateInput(value: string | null | undefined): string {
    return value ? value.substring(0, 10) : '';
  }

  private buildQuery(page: number, pageSize: number) {
    return {
      search: this.searchTerm.trim(),
      category: this.categoryFilter,
      isActive: this.activeFilter === '' ? undefined : this.activeFilter === 'true',
      page,
      pageSize
    };
  }

  get filterSummary(): string {
    const filters = [
      this.categoryFilter ? `Category: ${this.categoryFilter}` : 'All categories',
      this.activeFilter === '' ? 'All statuses' : this.activeFilter === 'true' ? 'Active only' : 'Inactive only',
      this.searchTerm.trim() ? `Search: ${this.searchTerm.trim()}` : ''
    ].filter(Boolean);
    return filters.join(' | ');
  }

  private escapeHtml(value: unknown): string {
    return String(value ?? '')
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&#039;');
  }

  private readError(error: any, fallback: string): string {
    return error?.error?.message || error?.message || fallback;
  }
}
