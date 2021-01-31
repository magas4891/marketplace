class SubscriptionsController < ApplicationController
  def new
    @project = Project.find(params[:project])
  end

  def create
    @project = Project.find(params[:project])
    Stripe.api_key = stripe_api_key

    if current_user.stripe_id?
      customer = current_user.stripe_id
    else
      customer = Stripe::CustomerCreateService.perform(current_user: current_user)

      Stripe::PaymentMethodAttachService.perform({ customer: customer,
                                                   payment_method: payment_method})

      Stripe::CustomerUpdateService.perform({ customer: customer,
                                              payment_method: payment_method})

      current_user.update(update_stripe_fields(customer))
    end

    stripe_subscription = Stripe::SubscriptionCreateService.perform({ customer: customer,
                                                      price_id: perk.stripe_price_id,
                                                      stripe_account: key })

    subscription = current_user.subscriptions.new(subscription_params(stripe_subscription))
    subscription.save!

    redirect_to root_path, notice: 'Your subscription was setup successfully!'
  end

  def destroy
    subscription_to_remove = params[:id]
    customer = Stripe::Customer.retrieve(current_user.stripe_id)
    customer.subscriptions.retrieve(subscription_to_remove).delete
    # current_user.subscribed = false

    redirect_to root_path, notice: 'Your subscription has been canceled'
  end

  private

  def stripe_api_key
    @project.user.access_code
  end

  def perk
    Perk.find(params[:plan])
  end

  def payment_method
    params[:paymentMethod].presence
  end

  def key
    @project.user.uid
  end

  def update_stripe_fields(customer)
    {
      stripe_id: customer.id,
      card_last4: params[:user][:card_last4],
      card_exp_month: params[:user][:card_exp_month],
      card_exp_year: params[:user][:card_exp_year],
      card_type: params[:user][:card_brand]
    }
  end

  def subscription_params(sub)
    {
      subscription_id: sub.id,
      perk: perk
    }
  end
end
