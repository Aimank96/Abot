require 'rails_helper'

describe Payer do
  let(:payer) do
    build(:payer)
  end

  it "has a valid factory" do
    expect(payer).to be_valid
  end
end
