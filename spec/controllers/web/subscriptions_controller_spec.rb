require 'rails_helper'

describe Web::SubscriptionsController do
  let(:user) do
    create(:user)
  end

  describe "#new" do
    it "works" do
      expect {
        get :new
      }.not_to raise_error
    end
  end

  describe "#create" do
    context "correct nonce" do
      before do
        allow(Subscription::Maker).to receive(:call) {
          true
        }
      end

      let(:params) do
        {
          nonce: "i_am_a_correct_nonce",
          user_id: user.id,
          first_name: "Janusz",
          last_name: "Kowalski",
          address: "Targowa 45, 92018 Lodz, Poland",
          email: "ppp@email.com"
        }
      end

      it "returns a correct status code" do
        post :create, params: params, format: :json
        expect(response.status).to eq 201
      end
    end

    context "missing params" do
      let(:params) { {} }

      it "returns a correct status code" do
        post :create, params: params, format: :json
        expect(response.status).to eq 403
      end
    end

    context "random payment error" do
      let(:params) do
        {
          nonce: "i_am_a_correct_nonce",
          user_id: user.id,
          first_name: "Janusz",
          last_name: "Kowalski",
          address: "Targowa 45, 92018 Lodz, Poland",
          email: "ppp@email.com"
        }
      end

      before do
        allow(Subscription::Maker).to receive(:call) {
          false
        }
      end

      it "returns a correct status code" do
        post :create, params: params, format: :json
        expect(response.status).to eq 400
      end
    end
  end
end
