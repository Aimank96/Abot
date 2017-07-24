FactoryGirl.define do
  factory :subscription do
    association :team
    association :payer, factory: :user
    amount_paid 5.0
  end
end
