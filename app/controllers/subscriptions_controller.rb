class SubscriptionsController < ApplicationController
  def new
    @project = Project.find(params[:project])
  end

  def create
    @project = Project.find(params[:project])
    key = @project.user.uid
    Stripe.api_key = @project.user.access_code

    plan_id = params[:plan]
    plan = Stripe::Plan.retrieve(plan_id)
    token = params[:stripeToken]

    customer = if current_user.stripe_id?
                 Stripe::Customer.retrieve(current_user.stripe_id)
               else
                 Stripe::Customer.create(email: current_user.email, source: token)
               end

    subscription = Stripe::Subscription.create({
                                                 customer: customer,
                                                 items: [
                                                   {
                                                     price: plan_id
                                                   }
                                                 ],
                                                 expand: ["latest_invoice.payment_intent"],
                                                 application_fee_percent: 10,
                                               }, stripe_account: key)
    options = {
      stripe_id: customer.id,
      subscribed: true,
      stripe_subscription_id: subscription.id
    }

    options.merge!(
      card_last4: params[:user][:card_last4],
      card_exp_month: params[:user][:card_exp_month],
      card_exp_year: params[:user][:card_exp_year],
      card_type: params[:user][:card_brand]
    )

    current_user.update(options)

    redirect_to root_path, notice: 'Your subscription was setup successfully!'
  end

  def destroy; end
end
