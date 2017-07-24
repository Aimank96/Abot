require 'rails_helper'
describe Slack::CommandInputParser do
  describe "#call" do
    subject do
      Slack::CommandInputParser.new.call(text)
    end

    context "feedback sent to channel with # prefix" do
      let(:text) do
        "#general meeting was too long"
      end

      it "strips # from channel name" do
        expected = {
          target: 'general',
          content: 'meeting was too long'
        }

        expect(subject).to eq expected
      end
    end

    context "feedback sent to channel without # prefix" do
      let(:text) do
        "general meeting was too long"
      end

      it "parses input correctly" do
        expected = {
          target: 'general',
          content: 'meeting was too long'
        }

        expect(subject).to eq expected
      end
    end

    context "feedback sent to user" do
      let(:text) do
        "@tom your mama"
      end

      it "parses input correctly" do
        expected = {
          target: '@tom',
          content: 'your mama'
        }

        expect(subject).to eq expected
      end
    end

    context "missing feedback content" do
      let(:text) do
        "#general"
      end

      it "raises a correct error" do
        expect {
          subject
        }.to raise_error Slack::MissingFeedbackError
      end
    end

    context "missing any content" do
      let(:text) do
        ""
      end

      it "raises a correct error" do
        expect {
          subject
        }.to raise_error Slack::MissingFeedbackError
      end
    end
  end
end
