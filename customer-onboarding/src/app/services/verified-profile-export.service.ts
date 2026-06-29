import { Injectable } from '@angular/core';
import { AdditionalCustomerDetails, CustomerProfileSnapshot } from '../models/onboarding.models';
import { CustomerOnboardingService } from './customer-onboarding.service';

@Injectable({ providedIn: 'root' })
export class VerifiedProfileExportService {
  private readonly logoPath = 'assets/branding/GB.png';

  constructor(private onboarding: CustomerOnboardingService) {}

  async downloadProfile(snapshot: CustomerProfileSnapshot, details?: AdditionalCustomerDetails | null): Promise<void> {
    const canvas = document.createElement('canvas');
    canvas.width = 1480;
    canvas.height = 980;
    const context = canvas.getContext('2d');

    if (!context) {
      return;
    }

    context.fillStyle = '#f4f8f4';
    context.fillRect(0, 0, canvas.width, canvas.height);

    const headerGradient = context.createLinearGradient(0, 0, canvas.width, 0);
    headerGradient.addColorStop(0, '#07522a');
    headerGradient.addColorStop(1, '#ebab23');
    context.fillStyle = headerGradient;
    context.fillRect(0, 0, canvas.width, 164);

    const logo = await this.loadImage(this.logoPath);
    if (logo) {
      context.drawImage(logo, 58, 26, 212, 112);
    }

    context.fillStyle = '#ffffff';
    context.font = '700 24px Inter, Segoe UI, Arial';
    context.fillText('Verified National ID Profile', 308, 72);
    context.font = '400 18px Inter, Segoe UI, Arial';
    context.fillText('Digital onboarding verification summary', 308, 108);

    this.drawPanel(context, 54, 194, 448, 718, '#ffffff');
    this.drawPanel(context, 532, 194, 894, 718, '#ffffff');

    const photoUrl = await this.onboarding.resolveIdentityPhotoPreview(snapshot.photoBase64);
    const photo = await this.loadImage(photoUrl);
    context.fillStyle = '#f8fafc';
    context.fillRect(90, 254, 376, 290);
    context.strokeStyle = '#d7e3da';
    context.lineWidth = 2;
    context.strokeRect(90, 254, 376, 290);

    if (photo) {
      context.drawImage(photo, 90, 254, 376, 290);
    } else {
      context.fillStyle = '#5f6f74';
      context.font = '600 18px Inter, Segoe UI, Arial';
      context.fillText('Customer photo not available', 156, 410);
    }

    context.fillStyle = '#07522a';
    context.font = '700 17px Inter, Segoe UI, Arial';
    context.fillText('Identity Summary', 90, 598);

    const leftRows = [
      ['Full name', snapshot.fullName],
      ['National ID / PSUT', snapshot.psut || snapshot.nationalId],
      ['Date of birth', snapshot.dateOfBirth],
      ['Gender', snapshot.gender],
      ['Residence status', snapshot.residenceStatus || 'Ethiopian'],
      ['Region / Zone', `${snapshot.regionName} / ${snapshot.zoneName}`],
      ['Woreda / Kebele', `${snapshot.woredaName} / ${snapshot.kebele}`]
    ];

    let cursorY = 638;
    leftRows.forEach(([label, value]) => {
      this.drawRow(context, 90, cursorY, 376, label, value || '-');
      cursorY += 46;
    });

    context.fillStyle = '#07522a';
    context.font = '700 17px Inter, Segoe UI, Arial';
    context.fillText('National ID Details', 570, 254);

    const rightRows = [
      ['Mobile number', details?.mobileNumber || snapshot.mobileNumber || ''],
      ['Email', details?.email || snapshot.email || ''],
      ['Place of birth', details?.placeOfBirth || snapshot.placeOfBirth || ''],
      ['ID type', details?.idType || 'Fayda / National ID'],
      ['Resident / Yellow card', details?.residentIdNumber || '']
    ].filter(([, value]) => !!value);

    cursorY = 294;
    rightRows.forEach(([label, value]) => {
      this.drawRow(context, 570, cursorY, 812, label, value);
      cursorY += 52;
    });

    context.fillStyle = '#6b7b83';
    context.font = '500 15px Inter, Segoe UI, Arial';
    context.fillText(
      `Generated on ${new Date().toLocaleString()} for branch operations and document archiving.`,
      570,
      872
    );

    const link = document.createElement('a');
    link.href = canvas.toDataURL('image/png');
    link.download = `${this.slugify(snapshot.fullName || 'verified-profile')}-verified-profile.png`;
    link.click();
  }

  private drawPanel(context: CanvasRenderingContext2D, x: number, y: number, width: number, height: number, fill: string): void {
    context.fillStyle = fill;
    context.strokeStyle = '#dce6de';
    context.lineWidth = 2;
    this.drawRoundedRectPath(context, x, y, width, height, 28);
    context.fill();
    context.stroke();
  }

  private drawRoundedRectPath(
    context: CanvasRenderingContext2D,
    x: number,
    y: number,
    width: number,
    height: number,
    radius: number
  ): void {
    const effectiveRadius = Math.min(radius, width / 2, height / 2);
    context.beginPath();
    context.moveTo(x + effectiveRadius, y);
    context.lineTo(x + width - effectiveRadius, y);
    context.quadraticCurveTo(x + width, y, x + width, y + effectiveRadius);
    context.lineTo(x + width, y + height - effectiveRadius);
    context.quadraticCurveTo(x + width, y + height, x + width - effectiveRadius, y + height);
    context.lineTo(x + effectiveRadius, y + height);
    context.quadraticCurveTo(x, y + height, x, y + height - effectiveRadius);
    context.lineTo(x, y + effectiveRadius);
    context.quadraticCurveTo(x, y, x + effectiveRadius, y);
    context.closePath();
  }

  private drawRow(context: CanvasRenderingContext2D, x: number, y: number, width: number, label: string, value: string): void {
    context.fillStyle = '#768692';
    context.font = '600 13px Inter, Segoe UI, Arial';
    context.fillText(label.toUpperCase(), x, y);

    context.fillStyle = '#152337';
    context.font = '700 18px Inter, Segoe UI, Arial';
    this.drawWrappedText(context, value, x, y + 28, width, 22);

    context.strokeStyle = '#e4ebe6';
    context.lineWidth = 1;
    context.beginPath();
    context.moveTo(x, y + 38);
    context.lineTo(x + width, y + 38);
    context.stroke();
  }

  private drawWrappedText(
    context: CanvasRenderingContext2D,
    text: string,
    x: number,
    y: number,
    maxWidth: number,
    lineHeight: number
  ): void {
    const words = (text || '-').split(/\s+/);
    let line = '';
    let currentY = y;

    words.forEach((word) => {
      const testLine = `${line}${word} `;
      if (context.measureText(testLine).width > maxWidth && line) {
        context.fillText(line.trim(), x, currentY);
        line = `${word} `;
        currentY += lineHeight;
        return;
      }

      line = testLine;
    });

    if (line.trim()) {
      context.fillText(line.trim(), x, currentY);
    }
  }

  private async loadImage(source: string): Promise<HTMLImageElement | null> {
    if (!source) {
      return null;
    }

    return new Promise((resolve) => {
      const image = new Image();
      image.onload = () => resolve(image);
      image.onerror = () => resolve(null);
      image.src = source;
    });
  }

  private slugify(value: string): string {
    return (value || 'verified-profile')
      .toLowerCase()
      .replace(/[^a-z0-9]+/g, '-')
      .replace(/^-+|-+$/g, '');
  }
}
