class RenameTable < ActiveRecord::Migration[7.0]
  def change
    rename_table :clients, :accounts
  end
end
