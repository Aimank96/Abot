FactoryGirl.define do
  factory :team do
    slack_id { SecureRandom.hex(5) }
    bot_slack_id { SecureRandom.hex(5) }
    bot_access_token { SecureRandom.hex }
    sequence(:name) { |n| "team_name_#{n}" }
  end
end
