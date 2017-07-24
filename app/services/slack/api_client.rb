class Slack::ApiClient < SmartInit::Base
  using HashHelpers

  API_HOST = 'https://slack.com'.freeze
  SLACK_CLIENT_ID = ENV.fetch("SLACK_CLIENT_ID")
  SLACK_CLIENT_SECRET = ENV.fetch("SLACK_CLIENT_SECRET")
  private_constants :API_HOST, :SLACK_CLIENT_ID, :SLACK_CLIENT_SECRET

  initialize_with :network_provider

  def self.build
    new(Faraday.new(API_HOST))
  end

  def post_message(auth_token, target, content)
    as_user = target.include?("@")

    response = network_provider.get('/api/chat.postMessage',
      token: auth_token,
      channel: target,
      text: content,
      as_user: as_user
    )

    raise Slack::ApiError, "There was a problem when posting a message" unless response.success?

    json = JSON.parse(response.body)

    unless json.fetch("ok") == true
      raise Slack::AuthError if json.fetch("error") == 'invalid_auth'
      raise Slack::MessageTargetError if json.fetch("error") == 'channel_not_found'
      raise Slack::ApiError, "Unhandled chat.postMessage error"
    end

    true
  end

  def get_oauth_data(access_code)
    response = network_provider.get('/api/oauth.access',
      client_id: SLACK_CLIENT_ID,
      client_secret: SLACK_CLIENT_SECRET,
      code: access_code
    )

    raise Slack::ApiError, "Could not get oauth data" unless response.success?

    json = JSON.parse(response.body)

    {
      user_access_token: json.fetch('access_token'),
      bot_access_token: json.deep_fetch('bot', 'bot_access_token'),
      bot_slack_id: json.deep_fetch('bot', 'bot_user_id'),
      team_slack_id: json.fetch('team_id'),
      user_slack_id: json.fetch('user_id'),
      team_name: json.fetch('team_name')
    }
  rescue KeyError
    raise Slack::ApiError, "Incorrect Slack api response format: #{json}"
  end
end
