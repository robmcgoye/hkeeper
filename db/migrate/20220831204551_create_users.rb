class CreateUsers < ActiveRecord::Migration[7.0]
  def change

    remove_column :users, :name
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :phone, :string
    add_column :users, :confirmed_at, :datetime

    create_table :user_accounts do |t|
      t.belongs_to :accounts
      t.belongs_to :users

      t.timestamps
    end

    add_index :users, :email, unique: true
  end
end
