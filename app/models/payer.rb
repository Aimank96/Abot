class Payer < ApplicationRecord
  belongs_to :team
  has_one :subscription

  delegate :has_access?, to: :team
end
