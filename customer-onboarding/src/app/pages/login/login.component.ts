import { Component, OnInit } from '@angular/core';
import { FormBuilder, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { AuthService } from 'src/app/services/auth.service';
import { ToastService } from 'src/app/services/toast.service';
import { environment } from 'src/environments/environment';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})
export class LoginComponent implements OnInit {
  readonly telebirrEnabled = environment.features.telebirrEnabled;

  loggingIn = false;
  loginError: string | null = null;

  form = this.fb.group({
    username: ['', [Validators.required, Validators.minLength(3)]],
    password: ['', [Validators.required, Validators.minLength(6)]]
  });

  constructor(
    private fb: FormBuilder,
    private auth: AuthService,
    private router: Router,
    private toast: ToastService
  ) {}

  ngOnInit(): void {
    if (!this.auth.isAuthenticated()) {
      return;
    }

    if (this.auth.mustChangePassword()) {
      this.router.navigate(['/change-password']);
      return;
    }

    this.router.navigate(['/workspace']);
  }

  submit(): void {
    this.loginError = null;
    this.form.markAllAsTouched();
    if (this.form.invalid) {
      return;
    }

    const { username, password } = this.form.getRawValue();
    this.loggingIn = true;

    this.auth.login(username || '', password || '').subscribe({
      next: (response) => {
        this.loggingIn = false;
        this.toast.success('Login successful', `Welcome back, ${response.user.fullName}.`);
        if (response.user.mustChangePassword) {
          this.router.navigate(['/change-password']);
          return;
        }

        this.router.navigate(['/workspace']);
      },
      error: (error: any) => {
        this.loggingIn = false;
        this.loginError = error?.error?.message || error?.message || 'Login failed. Please verify your credentials.';
        this.toast.error('Login failed', this.loginError || 'Login failed.');
      }
    });
  }
}
