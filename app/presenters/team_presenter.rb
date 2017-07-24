class TeamPresenter < SimpleDelegator
  include ActionView::Helpers::DateHelper
  alias_method :time_from_now_in_words, :time_ago_in_words

  def access_text
    if has_access?
      "Your team has already purchased Abot access. Enjoy!"
    else
      if has_valid_trial?
        "You have <b>#{trial_valid_until_text}</b> left until Abot trial period ends. #{purchase_text}"
      else
        "Your trial period is over. #{purchase_text}"
      end
    end.html_safe
  end

  private

  def purchase_text
    "You can purchase access for <b>the whole team</b> for #{Subscription::PRICE_READABLE} <a href='/web/subscriptions/new'>one-time payment</a> . No one from your will know that it was you who paid."
  end

  def trial_valid_until_text
    time_from_now_in_words(trial_valid_until)
  end
end
