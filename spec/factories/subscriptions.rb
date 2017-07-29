FactoryGirl.define do
  factory :subscription do
    association :team
    association :payer
    amount_paid 5.0
  end
end
