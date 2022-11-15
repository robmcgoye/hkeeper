class RenameCol < ActiveRecord::Migration[7.0]
  def change
    rename_column :computers, :client_id, :account_id
  end
end
