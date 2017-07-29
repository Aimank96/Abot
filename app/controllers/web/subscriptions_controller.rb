class Web::SubscriptionsController < Web::BaseController
  protect_from_forgery with: :null_session
  before_action :authenticate!, only: [:new]

  def new
    if @current_user.has_access?
      flash[:success] = "Your Team has already purchased Abot access."
      redirect_to root_path and return
    end

    gon.braintree_token = ENV.fetch("BRAINTREE_TOKEN")
    gon.user_id = @current_user.id
    @braintree_id = ENV.fetch("BRAINTREE_MERCHANT_ID")
  end

  def create
    user_id = params.fetch(:user_id)
    payment_successful = Subscription::Maker.call(
      nonce: params.fetch(:nonce),
      first_name: params.fetch(:first_name),
      last_name: params.fetch(:last_name),
      address: params.fetch(:address),
      email: params.fetch(:email),
      user_id: user_id,
    )

    if payment_successful
      NotifierJob.perform_later("$$$ New purchase! #{Payer.find(user_id).team.name} ")
      nonce = params.fetch(:nonce)
      render json: {
        status: "success"
      }, status: 201
    else
      render json: {
        error: "error_processing_payment"
      }, status: 400
    end
  end

  def confirm
    result = params.fetch(:result)
    if result == 'success'
      flash[:success] = "You successfully purchased Abot. Thanks for your support!"
    elsif result == 'error'
      flash[:error] = "There was a problem completing your subscription. Please try again. In case problem persists contact us via support email and we will fix it. I promise we will."
    end

    redirect_to root_path
  end
end
