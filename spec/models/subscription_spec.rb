require 'rails_helper'

describe Subscription do
  let(:subscription) do
    build(:subscription)
  end

  it "has a valid factory" do
    expect(subscription).to be_valid
  end
end
