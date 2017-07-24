class RemoveUneededConstrainsFromUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :webhook_channel_id, :string
    remove_column :users, :slack_access_token, :string
    add_column :users, :webhook_channel_id, :string
    add_column :users, :slack_access_token, :string
  end
end
