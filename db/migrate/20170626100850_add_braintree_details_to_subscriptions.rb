class AddBraintreeDetailsToSubscriptions < ActiveRecord::Migration[5.1]
  def change
    add_column :subscriptions, :braintree_identifier, :string
    add_column :subscriptions, :payer_first_name, :string
    add_column :subscriptions, :payer_last_name, :string
    add_column :subscriptions, :payer_address, :string
    add_column :subscriptions, :payer_email, :string
  end
end
