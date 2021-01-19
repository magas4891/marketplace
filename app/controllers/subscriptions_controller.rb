class SubscriptionsController < ApplicationController
  def new
    @project = Project.find(params[:project])
  end

  def create
    @project = Project.find(params[:project])
    key = @project.user.access_code
    Stripe.api_key = key

    plan_id = params[:plan]
    plan = Stripe::Plan.retrieve(plan_id)
    token = params[:stripeToken]

    pp "=", "KEY", key
    pp "=", "PLAN_ID", plan_id
    pp "=", "PLAN", plan
    pp "=", "TOKEN", token

    customer = if current_user.stripe_id?
                 Stripe::Customer.retrieve(current_user.stripe_id)
               else
                 Stripe::Customer.create(email: current_user.email, source: token)
               end

    pp "=", "CUSTOMER", customer

    Stripe::Subscription.create({
                                                 customer: customer,
                                                 items: [
                                                   {
                                                     price: '24-perk_1'
                                                   }
                                                 ],
                                                 expand: ["latest_invoice.payment_intent"],
                                                 application_fee_percent: 10,
                                               }, stripe_account: key)
    options = {
      stripe_id: customer.id,
      subscribed: true
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
