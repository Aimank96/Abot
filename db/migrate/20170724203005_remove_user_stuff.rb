class RemoveUserStuff < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :slack_access_token, :string
    remove_column :users, :webhook_channel_id, :string
  end
end
