class Web::BaseController < ApplicationController
  before_action :set_js_data

  layout 'web'

  rescue_from AuthenticationError do |e|
    ExceptionNotifier.notify_exception(e)
    respond_to do |format|
      format.html do
        flash[:error] = "Authenticate using 'Add to Slack' button to access this page."
        redirect_to root_path
      end

      format.json do
        render json: {
          error: "authentication_error"
        }, status: 401
      end
    end
  end

  rescue_from KeyError do |e|
    ExceptionNotifier.notify_exception(e)
    respond_to do |format|
      format.html do
        flash[:error] = "Invalid request"
        redirect_to root_path
      end

      format.json do
        render json: {
          error: "missing_param"
        }, status: 403
      end
    end
  end

  private

  def authenticate!
    authenticate || (raise AuthenticationError)
  end

  def authenticate
    if Rails.env.development?
      @current_user ||= User.find_by!(slack_id: 'develop')
    else
      @current_user ||= session[:current_user_id] &&
        User.find_by(id: session[:current_user_id])
    end

    @current_user
  end

  def set_js_data
    @controller = params.fetch(:controller)
    @action = params.fetch(:action)
  end
end
