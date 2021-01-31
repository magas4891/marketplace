module Stripe
  class PaymentMethodAttachService < ApplicationService
    def call
      Stripe::PaymentMethod.attach(
        payment_method,
        { customer: customer }
      )
    end
  end
end

