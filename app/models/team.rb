class Team < ApplicationRecord
  has_one :subscription
  has_one :payer

  def has_access?
    subscription.present?
  end

  def has_valid_trial?
    trial_valid_until > Date.today
  end

  def trial_valid_until
    (created_at + Subscription::BONUS_PERIOD).to_date
  end
end
