class CreateTeams < ActiveRecord::Migration[5.1]
  def change
    create_table :teams do |t|
      t.string :slack_id, null: false
      t.string :name, null: false
      t.string :bot_slack_id, null: false
      t.string :bot_access_token, null: false

      t.timestamps
    end
    add_index :teams, :slack_id, unique: true
  end
end
