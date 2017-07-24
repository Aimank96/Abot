FactoryGirl.define do
  factory :user do
    slack_id { SecureRandom.hex(5) }
    association :team
  end
end
