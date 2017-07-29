FactoryGirl.define do
  factory :payer do
    slack_id { SecureRandom.hex(5) }
    association :team
  end
end
