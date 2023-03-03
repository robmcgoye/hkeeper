class AddEmailedtoStatements < ActiveRecord::Migration[7.0]
  def change
    add_column :statements, :emailed_at, :datetime
  end
end
