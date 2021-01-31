module Stripe
  class CustomerUpdateService < ApplicationService
    def call
      Stripe::Customer.update(
        customer.id,
        { invoice_settings:
            { default_payment_method: payment_method }
        }
      )
    end
  end
end
