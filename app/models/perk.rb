class Perk < ApplicationRecord
  belongs_to :project
  has_many :subscriptions
end
