require 'rails_helper'
describe Slack::SubmitFeedback do
  let(:message_target) { "@pablo" }
  let(:message_content) { "Uważam że..." }

  subject do
    Slack::SubmitFeedback.new(slack_api_client)
      .call(team, message_target, message_content)
  end

  let(:team) do
    create(:team)
  end

  describe "#call" do
    context "message submit successful" do
      let(:slack_api_client) do
        double(
          post_message: true
        )
      end

      it "sends the feedback message and returns true" do
        expect(slack_api_client).to receive(:post_message)
        expect(subject).to eq true
      end

      it "increases the submited feedbacks count" do
        subject
        expect(team.reload.direct_feedbacks_count).to eq 1
      end
    end

    context "problem sending the message" do
      let(:slack_api_client) do
        double()
      end

      before do
        allow(slack_api_client).to receive(:post_message) {
          raise Slack::ApiError
        }
      end

      it "raises the correct error" do
        expect {
          subject
        }.to raise_error(Slack::ApiError)
      end
    end
  end
end
