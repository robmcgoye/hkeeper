class AddColumnsAccounts < ActiveRecord::Migration[7.0]
  def change
    add_column :accounts, :active, :boolean

    create_table :billers do |t|
      t.string :address_line_1
      t.string :address_line_2
      t.string :city
      t.string :state
      t.string :zip
      t.integer :user_id

      t.references :account, null: false, foreign_key: true
      t.timestamps
    end

    create_table :statements do |t|
      t.integer :invoice_number
      t.integer :terms
      t.integer :status

      t.references :account, null: false, foreign_key: true
      t.timestamps
    end

    create_table :line_items do |t|
      t.integer :quantity
      t.monetize :amount
      t.string :description
      
      t.references :statement, null: false, foreign_key: true
      t.timestamps
    end
  
  end
end
