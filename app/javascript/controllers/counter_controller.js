import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
    static targets = ["input"];

    connect() {
        // Set default value if empty
        if (!this.inputTarget.value) {
            this.inputTarget.value = 1;
        }
    }

    increment() {
        const currentValue = parseInt(this.inputTarget.value) || 1;
        this.inputTarget.value = currentValue + 1;
    }

    decrement() {
        const currentValue = parseInt(this.inputTarget.value) || 1;
        if (currentValue > 1) {
            this.inputTarget.value = currentValue - 1;
        }
    }
    setValue(event) {
        const value = parseInt(event.target.dataset.value, 10);
        this.inputTarget.value = value;
    }
}
