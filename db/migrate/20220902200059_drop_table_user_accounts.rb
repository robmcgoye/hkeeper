class DropTableUserAccounts < ActiveRecord::Migration[7.0]
  def up
    drop_table :user_accounts
  end

  def down
    fail ActiveRecord::IrreversibleMigration
  end
end
