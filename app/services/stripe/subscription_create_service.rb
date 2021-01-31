module Stripe
  class SubscriptionCreateService < ApplicationService
    def call
      pp "*"*50, Stripe.api_key

      Stripe::Subscription.create({
                                    customer: customer,
                                    items: [
                                      { price: price_id }
                                    ],
                                    expand: ["latest_invoice.payment_intent"],
                                    application_fee_percent: 10
                                  },
                                  stripe_account: key)
    end

    private

    def price_id
      params[:price_id].presence
    end

    def key
      params[:stripe_account].presence
    end
  end
end

