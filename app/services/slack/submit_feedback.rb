class Slack::SubmitFeedback < SmartInit::Base
  initialize_with :slack_api_client

  def self.call(team, target, content)
    new(Slack::ApiClient.build).call(team, target, content)
  end

  def call(team, target, content)
    slack_api_client.post_message(
      team.bot_access_token,
      target,
      decorate_content(target, content)
    )

    if target_is_user?(target)
      team.increment!(:direct_feedbacks_count)
    else
      team.increment!(:channel_feedbacks_count)
    end

    team.touch
    true
  end

  private

  def decorate_content(target, content)
    if target_is_user?(target)
      "Someone wanted to tell you that: \n\n#{content}"
    else
      "Someone thinks that: \n\n#{content}"
    end
  end

  def target_is_user?(target)
    target.include?("@")
  end
end
