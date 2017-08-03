class Subscription::Maker
  def self.call(params)
    new.call(params)
  end

  def call(params)
    result = Braintree::Transaction.sale(
      payment_method_nonce: params.fetch(:nonce),
      amount: Subscription::PRICE,
      options: {
        submit_for_settlement: true
      }
    )

    if result.success?
      payer = Payer.find(params.fetch(:user_id))
      Subscription.create!(
        team_id: payer.team_id,
        payer_id: payer.id,
        amount_paid: Subscription::PRICE,
        braintree_identifier: result.transaction.id,
        payer_first_name: params.fetch(:first_name),
        payer_last_name: params.fetch(:last_name),
        payer_address: params.fetch(:address),
        payer_email: params.fetch(:email)
      )
    end

    result.success?
  rescue Braintree::BraintreeError => e
    Rails.logger.error e
    ExceptionNotifier.notify_exception(e)
    false
  rescue => e
    Rails.logger.error e
    NotifierJob.perform_later("*!!!* Unhandled error processing payment for #{params.fetch(:user_id)}, action required")
    ExceptionNotifier.notify_exception(e)
    false
  end
end
