require 'rails_helper'

describe Subscription::Maker do
  describe "#call" do
    subject do
      Subscription::Maker.new.call(params)
    end

    let!(:team) do
      create(:user).team
    end

    context "everything is awesome" do
      let(:params) do
        {
          nonce: "3a5eeda2-b73b-038e-2f37-edfb89371c63",
          user_id: team.users.first.id,
          first_name: "Janusz",
          last_name: "Kowalski",
          address: "Targowa 45, 92018 Lodz, Poland",
          email: "ppp@email.com"
        }
      end

      it "creates a new subscription" do
        VCR.use_cassette("braintree_successful_payment") do
          expect {
            subject
          }.to change(Subscription, :count).by(1)
        end
      end

      it "returns true" do
        VCR.use_cassette("braintree_successful_payment") do
          expect(subject).to equal(true)
        end
      end

      it "last subscription has correct attributes" do
        VCR.use_cassette("braintree_successful_payment") do
          subject
          new_subscription = Subscription.last
          expect(new_subscription.payer).to eq team.users.first
          expect(new_subscription.team).to eq team
          expect(new_subscription.braintree_identifier).not_to be_nil
          expect(new_subscription.payer_first_name).not_to be_nil
          expect(new_subscription.payer_last_name).not_to be_nil
          expect(new_subscription.payer_email).not_to be_nil
        end
      end
    end

    context "something went wrong" do
      let(:params) do
        { nonce: "54321" }
      end

      context "nonce error" do
        it "does not create a new subscription" do
          VCR.use_cassette("braintree_nonce_error") do
            expect {
              subject
            }.not_to change(Subscription, :count)
          end
        end

        it "returns false" do
          VCR.use_cassette("braintree_auth_error") do
            expect(subject).to equal false
          end
        end
      end

      context "authentication error" do
        it "does not create a new subscription" do
          VCR.use_cassette("braintree_auth_error") do
            expect {
              subject
            }.not_to change(Subscription, :count)
          end
        end

        it "returns false" do
          VCR.use_cassette("braintree_auth_error") do
            expect(subject).to equal false
          end
        end
      end
    end
  end
end
