class Subscription < ApplicationRecord
  BONUS_PERIOD = 30.days
  PRICE = ENV.fetch("PRICE").to_i
  PRICE_READABLE = "#{PRICE}€"

  belongs_to :team
  belongs_to :payer, class_name: "User"
end
