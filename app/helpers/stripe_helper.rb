module StripeHelper
  def customer_help(resource)
    resource.subscriptions.each do |sub|
      perk = sub.perk
      project = perk.project
      project_owner = project.user
      Stripe.api_key = project_owner.access_code
      customer = Stripe::Customer.retrieve({
                                             id: resource.stripe_id,
                                             expand: ['subscriptions']
                                           })
      return customer.subscriptions.list.data
    end
  end
end
