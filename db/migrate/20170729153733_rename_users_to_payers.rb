class RenameUsersToPayers < ActiveRecord::Migration[5.1]
  def change
    rename_table :users, :payers
  end
end
