import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { CustomerDetailsComponent } from './pages/customer-details/customer-details.component';
import { FanVerificationComponent } from './pages/fan-verification/fan-verification.component';
import { ReviewSubmitComponent } from './pages/review-submit/review-submit.component';

const routes: Routes = [
  { path: '', pathMatch: 'full', redirectTo: 'fan-verification' },
  { path: 'fan-verification', component: FanVerificationComponent },
  { path: 'customer-details', component: CustomerDetailsComponent },
  { path: 'review-submit', component: ReviewSubmitComponent },
  { path: '**', redirectTo: 'fan-verification' }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule {}
