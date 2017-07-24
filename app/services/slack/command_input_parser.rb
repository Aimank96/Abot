class Slack::CommandInputParser
  def self.call(text)
    new.call(text)
  end

  def call(text)
    {
      target: extract_target(text) || (raise Slack::MissingFeedbackError),
      content: extract_content(text) || (raise Slack::MissingFeedbackError)
    }
  end

  private

  def extract_target(text)
    text.split(" ").first&.remove("#").presence
  end

  def extract_content(text)
    text.split(" ").from(1)&.join(" ").presence
  end
end
