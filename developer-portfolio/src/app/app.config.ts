import { importProvidersFrom } from '@angular/core';
import { HttpClientModule } from '@angular/common/http';
import { Meta, Title } from '@angular/platform-browser';
import { provideRouter, withEnabledBlockingInitialNavigation } from '@angular/router';

import { routes } from './app.routes';

export const appConfig = {
  providers: [
    importProvidersFrom(HttpClientModule),
    provideRouter(routes, withEnabledBlockingInitialNavigation()),
    Title,
    Meta
  ]
};
