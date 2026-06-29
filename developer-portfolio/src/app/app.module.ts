import { HttpClientModule } from '@angular/common/http';
import { NgModule } from '@angular/core';
import { ReactiveFormsModule } from '@angular/forms';
import { BrowserModule } from '@angular/platform-browser';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { StepperComponent } from './components/stepper/stepper.component';
import { CustomerDetailsComponent } from './pages/customer-details/customer-details.component';
import { FanVerificationComponent } from './pages/fan-verification/fan-verification.component';
import { ReviewSubmitComponent } from './pages/review-submit/review-submit.component';

@NgModule({
  declarations: [
    AppComponent,
    FanVerificationComponent,
    CustomerDetailsComponent,
    ReviewSubmitComponent,
    StepperComponent
  ],
  imports: [
    BrowserModule,
    HttpClientModule,
    ReactiveFormsModule,
    AppRoutingModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule {}
