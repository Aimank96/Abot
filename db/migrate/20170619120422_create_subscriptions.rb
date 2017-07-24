class CreateSubscriptions < ActiveRecord::Migration[5.1]
  def change
    create_table :subscriptions do |t|
      t.integer :team_id, null: false
      t.decimal :amount_paid, null: false, precision: 8, scale: 2
      t.integer :payer_id
      t.timestamps
    end

    add_index :subscriptions, :team_id, unique: true
    add_index :subscriptions, :payer_id, unique: true
  end
end
