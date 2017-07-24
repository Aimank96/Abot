class MoreSecurityStuff < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :direct_feedbacks_count, :integer
    remove_column :users, :channel_feedbacks_count, :integer
    remove_column :users, :created_at, :datetime
    remove_column :users, :updated_at, :datetime

    add_column :teams, :direct_feedbacks_count, :integer, null: false, default: 0
    add_column :teams, :channel_feedbacks_count, :integer, null: false, default: 0
  end
end
