class FixRelationships < ActiveRecord::Migration[7.0]
  def change
    add_column :statements, :service_id, :bigint
    add_column :statements, :service_type, :string
    add_index :statements, [:service_type, :service_id]
    
    remove_column :statements, :account_id
  end
end
