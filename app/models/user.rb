class User < ApplicationRecord
  belongs_to :team
  has_one :subscription, foreign_key: :payer_id

  delegate :has_access?, to: :team
end
