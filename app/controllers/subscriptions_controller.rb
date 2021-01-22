class SubscriptionsController < ApplicationController
  def new
    @project = Project.find(params[:project])
  end

  def create
    pp "="*200
    @project = Project.find(params[:project])
    key = @project.user.uid
    Stripe.api_key = @project.user.access_code

    perk_id = params[:perk]
    # plan = Stripe::Plan.retrieve(plan_id)
    token = params[:stripeToken]

    customer = Stripe::Customer.create(email: current_user.email)

    charge = Stripe::Charge.create({
                                     amount: 999,
                                     currency: 'usd',
                                     description: 'Example charge',
                                     source: token,
                                   })

    pp charge

    # customer = current_user.stripe_id? ? Stripe::Customer.retrieve(current_user.stripe_id) : Stripe::Customer.create(email: current_user.email, source: token)
    #
    # pp "CUSTOMER_"*5, customer

    # sub = Stripe::Subscription.create({
    #                                     customer: customer,
    #                                     items: [
    #                                       { price: perk_id }
    #                                     ],
    #                                     expand: ["latest_invoice.payment_intent"],
    #                                     application_fee_percent: 10
    #                                   },
    #                                   stripe_account: key)
    # pp "*"*100, sub

    # @subscription = Subscription.new(
    #   subscription_id: sub.id,
    #   user: current_user,
    #   perk: plan_id
    # )

    # options = {
    #   stripe_id: customer.id,
    #   subscribed: true
    #   # stripe_subscription_id: subscription.id
    # }
    #
    # options.merge!(
    #   card_last4: params[:user][:card_last4],
    #   card_exp_month: params[:user][:card_exp_month],
    #   card_exp_year: params[:user][:card_exp_year],
    #   card_type: params[:user][:card_brand]
    # )
    #
    # current_user.update(options)

    redirect_to root_path, notice: 'Your subscription was setup successfully!'
  end

  def destroy
    subscription_to_remove = params[:id]
    customer = Stripe::Customer.retrieve(current_user.stripe_id)
    customer.subscriptions.retrieve(subscription_to_remove).delete
    current_user.subscribed = false

    redirect_to root_path, notice: 'Your subscription has been canceled'
  end
end
