Slack::ApiError = Class.new(StandardError)
Slack::AuthError = Class.new(Slack::ApiError)
Slack::MessageTargetError = Class.new(Slack::ApiError)
Slack::MissingFeedbackError = Class.new(StandardError)

AuthenticationError = Class.new(StandardError)
