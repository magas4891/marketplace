class StripeCharges {
    constructor({ form, key }) {
        this.form = form;
        this.key = key;
        this.stripe = Stripe(this.key);
    }

    initialize() {
        this.mountCard();
    }

    mountCard() {
        const elements = this.stripe.elements();

        const style = {
            base: {
                color: '#32325d',
                fontWeight: 500,
                fontSize: '16px',
                fontSmoothing: 'antialiased',
                '::placeholder': {
                    color: '#cfd7df'
                },
                invalid: {
                    color: '#e25950'
                }
            }
        };

        const card = elements.create('card', { style });

        if (card) {
            card.mount('#card-element');
            this.generateToken(card);
        }
    }

    generateToken(card) {
        let self = this;

        this.form.addEventListener('submit', async (event) => {
            event.preventDefault();

            const { token, error } = await self.stripe.createToken(card);

            if ( error ) {
                const errorElement = document.getElementById('card-error');
                errorElement.textContent = error.message;
            } else {
                this.tokenHandler(token);
            }
        });
    }

    tokenHandler(token) {
        const hiddenInput = document.createElement('input');
        hiddenInput.setAttribute('type', 'hidden');
        hiddenInput.setAttribute('name', 'stripeToken');
        hiddenInput.setAttribute('value', token.id);
        this.form.appendChild(hiddenInput);

        ['brand', 'last4', 'exp_month', 'exp_year'].forEach(field => {
            self.addCardField(token, field);
        });
    }

    addCardField(token, field) {
        const hiddenInput = document.createElement('input');
        hiddenInput.setAttribute('type', 'hidden');
        hiddenInput.setAttribute('name', `user[card_${field}`);
        hiddenInput.setAttribute('value', token.card[field]);
        this.form.appendChild(hiddenInput);
    }
}

document.addEventListener("turbolinks:load", () => {
    const form = document.getElementById("payment-form");
    if ( form ) {
        const charge = new StripeCharges({
            form: form,
            key: form.dataset.stripeKey
        });
        charge.initialize();
    }
});