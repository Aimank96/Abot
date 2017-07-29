require 'rails_helper'
describe Slack::PayerLogin do
  subject do
    Slack::PayerLogin.new(slack_api_client)
  end

  let(:slack_api_client) do
    double(
      get_oauth_data: {
        user_access_token: 'user_access_token',
        bot_access_token: 'bot_access_token',
        team_slack_id: 'team_slack_id',
        user_slack_id: 'payer_slack_id',
        team_name: 'team_name',
        bot_slack_id: 'bot_slack_id'
      },
      post_message: true
    )
  end

  describe "creating the payer" do
    context "payer did not exist before" do
      it "creates a new payer" do
        expect {
          subject.call('access_code')
        }.to change(Payer, :count).by(1)
      end

      it "assigns correct payer attributes" do
        payer = subject.call('access_code')
        expect(payer.slack_id).to eq 'payer_slack_id'
      end
    end

    context "payer and team existed before" do
      before do
        team = create(:team, slack_id: 'team_slack_id')
        create(:payer, slack_id: 'payer_slack_id', team: team)
      end

      it "does not create a new payer" do
        expect {
          subject.call('access_code')
        }.not_to change(Payer, :count)
      end

      it "returns a correct payer instance" do
        expect(subject.call('access_code').slack_id).to eq 'payer_slack_id'
      end
    end
  end

  describe "assigning to the slack team" do
    context "this payer's team did not exist before" do
      it "creates a new team" do
        expect {
          subject.call('access_code')
        }.to change(Team, :count).by(1)
      end

      it "assigns one new payer to the team" do
        subject.call('access_code')
        new_team = Team.last
        expect(new_team.payer).not_to be_nil
      end
    end

    describe "this users team existed before" do
      let!(:team) do
        create(:team, slack_id: 'team_slack_id', bot_access_token: "old_token")
      end

      before do
        create(:payer, team: team)
      end

      it "updates the team access token" do
        subject.call('access_token')
        expect(team.reload.bot_access_token).to eq 'bot_access_token'
      end

      it "it does not create a new team" do
        expect {
          subject.call('access_code')
        }.not_to change(Team, :count)
      end
    end
  end
end
