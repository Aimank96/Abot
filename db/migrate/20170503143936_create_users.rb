class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.integer :direct_feedbacks_count, default: 0, null: false
      t.integer :channel_feedbacks_count, default: 0, null: false
      t.string :name
      t.string :team_id, null: false
      t.string :slack_id, null: false
      t.string :webhook_channel_id, null: false
      t.string :slack_access_token, null: false

      t.timestamps
    end
    add_index :users, :team_id
    add_index :users, :slack_id, unique: true
  end
end
