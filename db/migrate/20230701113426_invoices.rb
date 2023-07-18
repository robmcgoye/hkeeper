class Invoices < ActiveRecord::Migration[7.0]
  def change
    create_table :invoices do |t|
      t.bigint  :service_id
      t.string  :service_type

      t.references :statement, null: false, foreign_key: true
      t.timestamps
    end
    add_index :invoices, [:service_type, :service_id]
 
    remove_index :statements, [:service_type, :service_id]
    remove_column :statements, :service_id
    remove_column :statements, :service_type
  end
end
