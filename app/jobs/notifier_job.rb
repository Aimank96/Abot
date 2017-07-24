class NotifierJob < ApplicationJob
  def perform(message)
    Slack::Notifier.new(
      ENV.fetch("SLACK_WEBHOOK"),
      channel: "tracky",
      username: "Abot-#{Rails.env}"
    ).ping message, icon_emoji: ":goat:"
  end
end
