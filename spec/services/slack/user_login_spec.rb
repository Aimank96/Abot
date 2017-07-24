require 'rails_helper'
describe Slack::UserLogin do
  subject do
    Slack::UserLogin.new(slack_api_client)
  end

  let(:slack_api_client) do
    double(
      get_oauth_data: {
        user_access_token: 'user_access_token',
        bot_access_token: 'bot_access_token',
        team_slack_id: 'team_slack_id',
        user_slack_id: 'user_slack_id',
        team_name: 'team_name',
        bot_slack_id: 'bot_slack_id'
      },
      post_message: true
    )
  end

  describe "creating the user" do
    context "user did not exist before" do
      it "creates a new user" do
        expect {
          subject.call('access_code')
        }.to change(User, :count).by(1)
      end

      it "assigns correct user attributes" do
        user = subject.call('access_code')
        expect(user.slack_id).to eq 'user_slack_id'
      end
    end

    context "user and team existed before" do
      before do
        team = create(:team, slack_id: 'team_slack_id')
        create(:user, slack_id: 'user_slack_id', team: team)
      end

      it "does not create a new user" do
        expect {
          subject.call('access_code')
        }.not_to change(User, :count)
      end

      it "returns a correct user instance" do
        expect(subject.call('access_code').slack_id).to eq 'user_slack_id'
      end
    end
  end

  describe "assigning to the slack team" do
    context "this user's team did not exist before" do
      it "creates a new team" do
        expect {
          subject.call('access_code')
        }.to change(Team, :count).by(1)
      end

      it "assigns one new user to the team" do
        subject.call('access_code')
        new_team = Team.last
        expect(new_team.users.count).to eq 1
      end
    end

    describe "this users team existed before" do
      let!(:team) do
        create(:team, slack_id: 'team_slack_id', bot_access_token: "old_token")
      end

      before do
        create(:user, team: team)
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

      it "assigns a new user to the correct team" do
        subject.call('access_code')
        new_team = Team.last
        expect(new_team.users.count).to eq 2
      end
    end
  end
end
