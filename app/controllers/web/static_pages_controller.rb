class Web::StaticPagesController < Web::BaseController
  before_action :authenticate
  def home
    if @current_user
      @team = TeamPresenter.new(@current_user.team)
    end

    @add_to_slack_url = ENV.fetch("ADD_TO_SLACK_URL")
  end
end
