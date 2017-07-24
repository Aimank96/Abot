class Slack::BaseController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :check_token!

  layout "slack"

  rescue_from StandardError do |e|
    ExceptionNotifier.notify_exception(e)
    render :error
  end

  def render partial, opts={}
    super(partial, opts.merge(formats: [:text]))
  end

  private

  def check_token!
    unless params.fetch(:token) == ENV.fetch('SLACK_TOKEN')
      NotifierJob.perform_later("Invalid slack token access attempt")
      render "slack/static/invalid_token" and return
    end
  end

  def check_access!
    @team = Team.find_by!(slack_id: params.fetch(:team_id))
    if !@team.has_access? && !@team.has_valid_trial?
      render "slack/static/trial_is_over", locals: {
        price: Subscription::PRICE_READABLE,
        purchase_link: "#{ENV.fetch('HOST')}/web/subscriptions/new"
      } and return
    end
  end

  def current_team
    @team
  end
end
