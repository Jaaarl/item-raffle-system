import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
    static targets = ["input"];

    connect() {
        // Set default value if empty
        if (!this.inputTarget.value) {
            this.inputTarget.value = 0;
        }
    }

    increment() {
        const currentValue = parseInt(this.inputTarget.value) || 0;
        this.inputTarget.value = currentValue + 1;
    }

    decrement() {
        const currentValue = parseInt(this.inputTarget.value) || 0;
        if (currentValue > 0) {
            this.inputTarget.value = currentValue - 1;
        }
    }
}
