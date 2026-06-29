import { Injectable } from '@angular/core';
import { TelebirrTransferRecord } from '../models/onboarding.models';

@Injectable({ providedIn: 'root' })
export class ReceiptPrintService {
  private readonly logoPath = 'assets/branding/GB.png';
  private readonly watermarkPath = 'assets/receipt/watermark-cropped.png';
  private readonly stampPath = 'assets/receipt/stamp-cropped.png';

  canPrintForStatus(status: string | null | undefined): boolean {
    const normalized = (status || '').trim().toUpperCase();
    return normalized === 'APPROVED' || normalized === 'COMPLETED';
  }

  printTelebirrReceipt(record: TelebirrTransferRecord): void {
    const printWindow = window.open('', '_blank', 'width=920,height=980');
    if (!printWindow) {
      return;
    }

    const transferDate = this.formatDate(record.approvedAt || record.createdAt);
    const printDate = this.formatDate(new Date().toISOString());
    const telebirrAgentReference = this.resolveTelebirrAgentReference(record);

    const html = `<!doctype html>
<html>
<head>
  <meta charset="utf-8" />
  <title>Telebirr Transfer Receipt</title>
  <style>
    @page { size: A4; margin: 18mm; }
    body { margin: 0; font-family: Inter, Segoe UI, Arial, sans-serif; background: #f8f9f7; }
    .receipt {
      width: 100%;
      max-width: 760px;
      margin: 0 auto;
      background: #ffffff;
      border: 1px solid #d8e4dc;
      border-radius: 18px;
      overflow: hidden;
      position: relative;
      box-shadow: 0 18px 40px rgba(8, 47, 25, 0.16);
    }
    .watermark {
      position: absolute;
      inset: 100px 80px 120px 80px;
      background: url('${this.watermarkPath}') center center/contain no-repeat;
      opacity: 0.06;
      pointer-events: none;
      z-index: 0;
    }
    .header {
      position: relative;
      z-index: 1;
      padding: 20px 26px 14px;
      background: linear-gradient(120deg, #f8edca 0%, #eef8f1 55%, #e8f2eb 100%);
      border-bottom: 3px solid #07522a;
      display: flex;
      align-items: center;
      gap: 14px;
    }
    .header img { height: 62px; width: auto; }
    .title { font-size: 14px; letter-spacing: 0.16em; color: #07522a; font-weight: 700; text-transform: uppercase; }
    .headline { font-size: 26px; font-weight: 900; color: #10233f; margin-top: 2px; }
    .subhead { font-size: 13px; color: #3f5576; font-weight: 600; margin-top: 3px; }
    .content { position: relative; z-index: 1; padding: 22px 26px 20px; }
    .grid {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 10px 20px;
    }
    .row { display: flex; justify-content: space-between; gap: 10px; border-bottom: 1px dashed #d4ded8; padding: 7px 0; }
    .label { color: #5b6f79; font-size: 12px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.06em; }
    .value { color: #132238; font-size: 13px; font-weight: 700; text-align: right; }
    .status {
      margin-top: 16px;
      display: inline-flex;
      align-items: center;
      gap: 8px;
      padding: 8px 14px;
      border-radius: 999px;
      font-weight: 800;
      letter-spacing: 0.08em;
      text-transform: uppercase;
      font-size: 12px;
      background: ${this.resolveStatusColor(record.status).background};
      color: ${this.resolveStatusColor(record.status).foreground};
    }
    .footer {
      position: relative;
      z-index: 1;
      padding: 16px 26px 24px;
      border-top: 1px solid #dbe5df;
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 20px;
    }
    .signature-box { border-top: 1px solid #8ea398; padding-top: 8px; font-size: 12px; color: #365148; font-weight: 700; }
    .stamp {
      position: absolute;
      right: 24px;
      bottom: 16px;
      width: 170px;
      opacity: 0.72;
      z-index: 1;
    }
    .meta { margin-top: 10px; font-size: 11px; color: #5f7480; }
    @media print {
      body { background: #fff; }
      .receipt { box-shadow: none; border: 1px solid #d3ddd7; }
    }
  </style>
</head>
<body>
  <div class="receipt">
    <div class="watermark"></div>
    <div class="header">
      <img src="${this.logoPath}" alt="GBE Logo" />
      <div>
        <div class="title">Global Bank Ethiopia</div>
        <div class="headline">Transaction Advice</div>
        <div class="subhead">TeleBirr Merchant Transfer (TLBM)</div>
      </div>
    </div>

    <div class="content">
      <div class="grid">
        ${this.row('Branch', `${this.escapeHtml(record.accountBranchCode || '-')}`)}
        ${this.row('Sender Account', this.escapeHtml(record.accountNumber))}
        ${this.row('Account Holder', this.escapeHtml(record.customerName || '-'))}
        ${this.row('Beneficiary Ref', this.escapeHtml(telebirrAgentReference))}
        ${this.row('Beneficiary Name', this.escapeHtml(record.telebirrOrganizationName || '-'))}
        ${this.row('Agent Code', this.escapeHtml(record.telebirrShortCode || '-'))}
        ${this.row('Transfer Amount', `${(record.amount || 0).toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })} ${this.escapeHtml(record.currency || 'ETB')}`)}
        ${this.row('Transfer Date', transferDate)}
        ${this.row('Bank Ref No', this.escapeHtml(record.cbsReference || '-'))}
        ${this.row('External Ref No', this.escapeHtml(telebirrAgentReference))}
        ${this.row('Maker', this.escapeHtml(record.makerUserName || '-'))}
        ${this.row('Checker', this.escapeHtml(record.checkerUserName || '-'))}
      </div>

      <div class="status">${this.escapeHtml(record.status || 'UNKNOWN')}</div>
      <div class="meta">Print Date: ${printDate}</div>
    </div>

    <div class="footer">
      <div class="signature-box">Maker Signature</div>
      <div class="signature-box">Checker Signature</div>
    </div>

    <img class="stamp" src="${this.stampPath}" alt="Official Stamp" />
  </div>

  <script>
    window.onload = function () {
      setTimeout(function () {
        window.print();
      }, 200);
    };
  </script>
</body>
</html>`;

    printWindow.document.open();
    printWindow.document.write(html);
    printWindow.document.close();
  }

  private row(label: string, value: string): string {
    return `<div class="row"><span class="label">${this.escapeHtml(label)}</span><span class="value">${value}</span></div>`;
  }

  private resolveStatusColor(status: string): { background: string; foreground: string } {
    const normalized = (status || '').toUpperCase();
    if (normalized === 'APPROVED') {
      return { background: '#dcfce7', foreground: '#166534' };
    }
    if (normalized === 'FAILED') {
      return { background: '#fef3c7', foreground: '#92400e' };
    }
    if (normalized === 'REJECTED') {
      return { background: '#ffe4e6', foreground: '#9f1239' };
    }
    return { background: '#e2e8f0', foreground: '#334155' };
  }

  private escapeHtml(value: string): string {
    return (value || '')
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&#39;');
  }

  private formatDate(value: string): string {
    const date = new Date(value);
    if (Number.isNaN(date.getTime())) {
      return '-';
    }
    return date.toLocaleString();
  }

  private resolveTelebirrAgentReference(record: TelebirrTransferRecord): string {
    return record.transactionId || record.conversationId || record.originatorConversationId || '-';
  }
}
