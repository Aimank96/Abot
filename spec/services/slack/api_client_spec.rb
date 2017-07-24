require 'rails_helper'
describe Slack::ApiClient do
  let(:api_host) do
    'https://slack.com'
  end

  subject do
    Slack::ApiClient.new(network_provider)
  end

  describe "get_oauth_data" do
    let(:oauth_data_endpoint) do
      '/api/oauth.access'
    end

    let(:oauth_data_response) do
      File.open(
        'spec/fixtures/oauth_login_response.json'
      ).read
    end

    context "data fetch successful" do
      let(:network_provider) do
        Faraday.new(api_host) do |builder|
          builder.adapter :test, nil do |stub|
            stub.get(oauth_data_endpoint) do |env|
              [200, {}, oauth_data_response]
            end
          end
        end
      end

      it "returns the expected data" do
        expected = {
          user_access_token: 'user_access_token',
          bot_access_token: 'bot_access_token',
          team_slack_id: 'team_slack_id',
          user_slack_id: 'user_slack_id',
          team_name: 'team_name',
          bot_slack_id: 'bot_slack_id'
        }

        result = subject.get_oauth_data('whatever')
        expect(result).to eq expected
      end
    end

    context "there was a problem" do
      let(:network_provider) do
        Faraday.new(api_host) do |builder|
          builder.adapter :test, nil do |stub|
            stub.get(oauth_data_endpoint) do |env|
              [500, {}, { error: "dupa" }.to_json]
            end
          end
        end
      end

      it "raises a correct error" do
        expect {
          subject.get_oauth_data('whatever')
        }.to raise_error(Slack::ApiError)
      end
    end
  end

  describe "post_message" do
    let(:token) { 'correct_auth_token' }
    let(:target) { 'general' }
    let(:content) { 'Uważam że...' }
    let(:network_provider) do
      Faraday.new(api_host) do |builder|
        builder.adapter :test, nil do |stub|
          stub.get('/api/chat.postMessage') do |env|
            [200, {}, post_message_response.to_json]
          end
        end
      end
    end

    context "message posted succesfully" do
      let(:post_message_response) do
        {
          "ok" => true,
          "channel" => "G596FQ19P",
          "ts" => "1494104800.571114",
          "message" => {
            "text" => "uważam właśnietak że",
            "username" => "Abot - Anonymous Feedback",
            "bot_id" => "B586NLHE1",
            "type" => "message",
            "subtype" => "bot_message",
            "ts" => "1494104800.571114"
          }
        }
      end

      it "returns true" do
        result = subject.post_message(token, target, content)
        expect(result).to eq true
      end
    end

    context "token is incorrect" do
      let(:post_message_response) do
        {
          "ok" => false,
          "error" => "invalid_auth"
        }
      end

      it "raises a correct error" do
        expect {
          subject.post_message(token, target, content)
        }.to raise_error(Slack::AuthError)
      end
    end

    context "target user or channel was not found" do
      let(:post_message_response) do
        {
          "ok" => false,
          "error" => "channel_not_found"
        }
      end

      it "raises a correct error" do
        expect {
          subject.post_message(token, target, content)
        }.to raise_error(Slack::MessageTargetError)
      end
    end
  end
end
