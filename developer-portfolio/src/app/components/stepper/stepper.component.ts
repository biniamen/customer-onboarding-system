import { Component, Input } from '@angular/core';

@Component({
  selector: 'app-stepper',
  templateUrl: './stepper.component.html',
  styleUrls: ['./stepper.component.css']
})
export class StepperComponent {
  @Input() steps: Array<{ label: string; route: string }> = [];
  @Input() currentRoute = '';

  isActive(route: string): boolean {
    return this.currentRoute === route;
  }

  isComplete(route: string): boolean {
    const currentIndex = this.steps.findIndex((step) => step.route === this.currentRoute);
    const stepIndex = this.steps.findIndex((step) => step.route === route);
    return currentIndex > stepIndex;
  }
}
