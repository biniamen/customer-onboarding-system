import { Injectable } from '@angular/core';
import { BehaviorSubject } from 'rxjs';

export interface ToastMessage {
  id: number;
  type: 'success' | 'error' | 'info';
  title: string;
  message: string;
}

@Injectable({ providedIn: 'root' })
export class ToastService {
  private readonly toastsSubject = new BehaviorSubject<ToastMessage[]>([]);
  private nextId = 1;

  readonly toasts$ = this.toastsSubject.asObservable();

  success(title: string, message: string): void {
    this.push('success', title, message);
  }

  error(title: string, message: string): void {
    this.push('error', title, message);
  }

  info(title: string, message: string): void {
    this.push('info', title, message);
  }

  dismiss(id: number): void {
    this.toastsSubject.next(this.toastsSubject.value.filter((toast) => toast.id !== id));
  }

  private push(type: ToastMessage['type'], title: string, message: string): void {
    const toast: ToastMessage = {
      id: this.nextId++,
      type,
      title,
      message
    };

    this.toastsSubject.next([...this.toastsSubject.value, toast]);
    setTimeout(() => this.dismiss(toast.id), 4500);
  }
}
