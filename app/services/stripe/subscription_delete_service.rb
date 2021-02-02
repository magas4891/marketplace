module Stripe
  class SubscriptionDeleteService < ApplicationService
    def call
      Stripe::Subscription.delete(subscription_id)
    end

    private

    def subscription_id
      params[:subscription_id]
    end
  end
end

