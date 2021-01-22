class CreateSubscriptions < ActiveRecord::Migration[6.0]
  def change
    create_table :subscriptions do |t|
      t.string :subscription_id
      t.references :user, null: false, foreign_key: true
      t.references :perk, null: false, foreign_key: true

      t.timestamps
    end
  end
end
