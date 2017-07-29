require 'rails_helper'
describe Web::SessionsController do
  describe "#create" do
    it "calls the correct service and logs in the user" do
      expect(Slack::PayerLogin).to receive(:call).with('oauth_code') { double(id: 1)}
      post :create, params: { code: 'oauth_code' }
      expect(session[:current_user_id]).to eq 1
    end
  end
end
