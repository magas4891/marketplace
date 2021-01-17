class StripeCharges {
    constructor({ form, key }) {
        this.form = form;
        this.key = key;
        this.stripe = Stripe(this.key);
    }
}