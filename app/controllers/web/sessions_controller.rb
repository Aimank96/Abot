class Web::SessionsController < Web::BaseController
  protect_from_forgery with: :null_session

  def create
    if user = Slack::UserLogin.call(params.fetch('code'))
      session[:current_user_id] = user.id
      flash[:success] = "You succesfully added Abot to your Slack team!"
    else
      flash[:error] = "There was a problem adding Abot to your team. Please try again or contact the support."
    end
    redirect_to root_path
  end

  def destroy
    session[:current_user_id] = nil
    flash[:success] = "You have been signed out."
    redirect_to root_path
  end
end
