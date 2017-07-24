require 'rails_helper'
describe Slack::FeedbacksController do
  describe "#create" do
    let(:team) do
      create(:team)
    end

    let(:params) do
      {
        team_id: team.slack_id,
        user_name: "pablo",
        text: "general whatever",
        token: ENV.fetch("SLACK_TOKEN")
      }
    end

    it "calls the appropriate service object" do
      expect(Slack::CommandInputParser).to receive(:call) {
        { target: 'general', content: 'whatever '}
      }
      expect(Slack::SubmitFeedback).to receive(:call)
      post :create, params: params
    end
  end
end
