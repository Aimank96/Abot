require 'rails_helper'

describe User do
  let(:user) do
    build(:user)
  end

  it "has a valid factory" do
    expect(user).to be_valid
  end
end
