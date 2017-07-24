class Slack::StaticController < Slack::BaseController
  def help
    render :help
  end

  def missing_content
    render :missing_content
  end
end
