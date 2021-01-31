module Stripe
  class CustomerCreateService < ApplicationService
    def call
      pp "*"*50, Stripe.api_key

      Stripe::Customer.create(email: current_user.email)
    end
  end
end
