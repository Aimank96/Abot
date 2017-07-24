class Slack::FeedbacksController < Slack::BaseController
  before_action :check_access!

  def create
    user_input = Slack::CommandInputParser.call(
      params.fetch(:text)
    )

    Slack::SubmitFeedback.call(
      current_team,
      user_input.fetch(:target),
      user_input.fetch(:content)
    )

    render :feedback_sent, locals: {
      target: decorate_target(user_input.fetch(:target))
    }
  rescue Slack::MessageTargetError
    render :target_error, locals: {
      target: decorate_target(user_input.fetch(:target))
    }
  rescue Slack::MissingFeedbackError
    render "slack/static/missing_content"
  end

  private

  def decorate_target(target)
    if target.include?("@")
      target
    else
      "##{target}"
    end
  end
end

