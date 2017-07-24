class Slack::UserLogin < SmartInit::Base
  initialize_with :slack_api_client

  def self.call(access_code)
    new(Slack::ApiClient.build).call(access_code)
  end

  def call(access_code)
    @data = slack_api_client.get_oauth_data(access_code)

    if user && team
      update_team(team)
      user
    elsif team
      update_team(team)
      create_user(team.id)
    else
      new_team = create_team
      create_user(new_team.id)
    end
  rescue ActiveRecord::RecordInvalid => e
    ExceptionNotifier.notify_exception(e)
    false
  end

  private

  def user
    @_user ||= User.find_by(slack_id: @data.fetch(:user_slack_id))
  end

  def team
    @_team ||= Team.find_by(slack_id: @data.fetch(:team_slack_id))
  end

  def update_team(team_to_update)
    team_to_update.update!(
      bot_access_token: @data.fetch(:bot_access_token)
    )
  end

  def create_team
    new_team = Team.create!(
      slack_id: @data.fetch(:team_slack_id),
      bot_slack_id: @data.fetch(:bot_slack_id),
      bot_access_token: @data.fetch(:bot_access_token),
      name: @data.fetch(:team_name)
    )

    if Team.count % 5 == 0
      NotifierJob.perform_later(
        "New team: #{new_team.name}, 'Add to Slack'. Total teams: #{Team.count}, Total users: #{User.count}"
      )
    end

    slack_api_client.post_message(
      team.bot_access_token,
      "general",
      welcome_message_content
    )

    new_team
  rescue => e
    Rails.logger.error e
    new_team
  end

  def create_user(team_id)
    new_user = User.create!(
      slack_id: @data.fetch(:user_slack_id),
      team_id: team_id
    )

    new_user
  end

  def welcome_message_content
    File.read(
      "#{Rails.root}/app/views/slack/static/welcome_message.text"
    )
  end
end
