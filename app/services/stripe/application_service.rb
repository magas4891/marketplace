module Stripe
  class ApplicationService < ApplicationService
    # Stripe.api_key = params[:stripe_api_key].presence

    private

    def current_user
      params[:current_user].presence
    end

    def customer
      params[:customer].presence
    end

    def payment_method
      params[:payment_method].presence
    end
  end
end
