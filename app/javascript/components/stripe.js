document.addEventListener("turbolinks:load", () => {
    var form = document.querySelector('#payment-form');
    if (form) {
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
        form.addEventListener("submit", async (event) => {
            event.preventDefault();
            form.getElementsByTagName('button')[0].setAttribute('disabled', 'disabled')
            const {paymentMethod, error} = await stripe.createPaymentMethod({
                type: 'card',
                card: card,
            });
            if (error) {
                const errorElement = document.getElementById('card-errors');
                errorElement.textContent = error.message;
            } else {
                console.log(paymentMethod);
                stripeTokenHandler(paymentMethod);
            }
        });
    }

// Submit the form with the token ID.
    function stripeTokenHandler(paymentMethod) {
        // Insert the token ID into the form so it gets submitted to the server
        var form = document.getElementById('payment-form');
        var hiddenInput = document.createElement('input');
        hiddenInput.setAttribute('type', 'hidden');
        hiddenInput.setAttribute('name', 'paymentMethod');
        hiddenInput.setAttribute('value', paymentMethod.id);
        form.appendChild(hiddenInput);

        ["brand", "last4", "exp_month", "exp_year"].forEach(function (field) {
            addCardField(paymentMethod, field);
        });

        // Submit the form
        form.submit();
    }

    function addCardField(paymentMethod, field) {
        let hiddenInput = document.createElement('input');
        hiddenInput.setAttribute('type', 'hidden');
        hiddenInput.setAttribute('name', "user[card_" + field + "]");
        hiddenInput.setAttribute('value', paymentMethod.card[field]);
        form.appendChild(hiddenInput);
     }
});
