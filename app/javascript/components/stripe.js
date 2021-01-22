// class StripeCharges {
//     constructor({ form, key }) {
//         this.form = form;
//         this.key = key;
//         this.stripe = Stripe(this.key)
//     }
//
//
//     initialize() {
//         console.log("STRIPE_CHARGES_CLASS");
//         this.mountCard()
//     }
//
//     mountCard() {
//         const elements = this.stripe.elements();
//
//         const style = {
//             base: {
//                 color: "#32325D",
//                 fontWeight: 500,
//                 fontSize: "16px",
//                 fontSmoothing: "antialiased",
//
//                 "::placeholder": {
//                     color: "#CFD7DF"
//                 },
//                 invalid: {
//                     color: "#E25950"
//                 }
//             },
//         };
//
//         const card = elements.create('card', { style });
//         if (card) {
//             card.mount('#card-element');
//             this.generateToken(card);
//         }
//     }
//
//     generateToken(card) {
//         console.log("GENERATE_TOKEN")
//         let self = this;
//         this.form.addEventListener('submit', async (event) => {
//             console.log("GENERATE_TOKEN SUBMIT_EVENT")
//             event.preventDefault();
//
//             const { token, error } = await self.stripe.createToken(card);
//
//             if (error) {
//                 const errorElement = document.getElementById('card-errors');
//                 errorElement.textContent = error.message;
//             } else {
//                 this.tokenHandler(token);
//             }
//         });
//     }
//
//     tokenHandler(token) {
//         console.log("TOKEN_HANDLER");
//         let self = this;
//         const hiddenInput = document.createElement('input');
//         hiddenInput.setAttribute('type', 'hidden');
//         hiddenInput.setAttribute('name', 'stripeToken');
//         hiddenInput.setAttribute('value', token.id);
//         this.form.appendChild(hiddenInput);
//
//         ["brand", "last4", "exp_month", "exp_year"].forEach(function (field) {
//             self.addCardField(token, field);
//         });
//         this.form.submit();
//     }
//
//     addCardField(token, field) {
//         let hiddenInput = document.createElement('input');
//         hiddenInput.setAttribute('type', 'hidden');
//         hiddenInput.setAttribute('name', "user[card_" + field + "]");
//         hiddenInput.setAttribute('value', token.card[field]);
//         this.form.appendChild(hiddenInput);
//     }
// }
//
// // Kick it all off
// document.addEventListener("turbolinks:load", () => {
//     const form = document.querySelector('#payment-form')
//     if (form) {
//         const charge = new StripeCharges({
//             form: form,
//             key: form.dataset.stripeKey
//         });
//         charge.initialize()
//     }
// })
document.addEventListener("turbolinks:load", () => {
    var form = document.querySelector('#payment-form');
    var stripe = Stripe(form.dataset.stripeKey);

    var elements = stripe.elements();

    var style = {
        base: {
            color: '#32325d',
            fontFamily: '"Helvetica Neue", Helvetica, sans-serif',
            fontSmoothing: 'antialiased',
            fontSize: '16px',
            '::placeholder': {
                color: '#aab7c4'
            }
        },
        invalid: {
            color: '#fa755a',
            iconColor: '#fa755a'
        }
    };

    var card = elements.create('card', {style: style});

    card.mount('#card-element');

    card.on('change', function(event) {
        var displayError = document.getElementById('card-errors');
        if (event.error) {
            displayError.textContent = event.error.message;
        } else {
            displayError.textContent = '';
        }
    });

// Handle form submission.
    var form = document.getElementById('payment-form');
    debugger

    form.addEventListener('submit', function(event) {
        event.preventDefault();
        stripe.createToken(card).then(function(result) {
            console.log(result);
            if (result.error) {
                // Inform the user if there was an error.
                var errorElement = document.getElementById('card-errors');
                errorElement.textContent = result.error.message;
            } else {
                // Send the token to your server.
                stripeTokenHandler(result.token);
            }
        })
    });

// Submit the form with the token ID.
    function stripeTokenHandler(token) {
        // Insert the token ID into the form so it gets submitted to the server
        var form = document.getElementById('payment-form');
        var hiddenInput = document.createElement('input');
        hiddenInput.setAttribute('type', 'hidden');
        hiddenInput.setAttribute('name', 'stripeToken');
        hiddenInput.setAttribute('value', token.id);
        form.appendChild(hiddenInput);

        // Submit the form
        form.submit();
    }
});
