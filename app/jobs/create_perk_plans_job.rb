# frozen_string_literal: true
class CreatePerkPlansJob < ApplicationJob
  queue_as :default

  def perform(project)
    key = project.user.access_code
    Stripe.api_key = key

    prod = Stripe::Product.create(name: project.title)

    project.perks.each do |perk|
      price = Stripe::Price.create(currency: 'usd',
                                   unit_amount: (perk.amount.to_r * 100).to_i,
                                   recurring: { interval: 'month' },
                                   nickname: "#{perk.title.parameterize}-perk_#{perk.id}",
                                   product: prod.id)
      perk.update(stripe_price_id: price.id)
    end

    # project.perks.each do |perk|
    #   Stripe::Plan.create(
    #     id: "#{perk.title.parameterize}-perk_#{perk.id}",
    #     amount: (perk.amount.to_r * 100).to_i,
    #     currency: 'usd',
    #     interval: 'month',
    #     product: { name: perk.title },
    #     nickname: perk.title.parameterize
    #   )
    # end
  end
end
