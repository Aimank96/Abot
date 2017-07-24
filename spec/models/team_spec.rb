require 'rails_helper'

describe Team do
  let(:team) do
    build(:team)
  end

  it "has a valid factory" do
    expect(team).to be_valid
  end

  describe "#has_access?" do
    let(:team) do
      create(:team, created_at: 1.week.ago)
    end

    context "team does not have a subscription" do
      it "returns a correct valid until date" do
        expect(team.has_access?).to eq false
      end
    end

    context "team has a subscription" do
      before do
        create(:subscription, team: team)
      end

      it "returns a correct valid until date" do
        expect(team.has_access?).to eq true
      end
    end
  end
end
