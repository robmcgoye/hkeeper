class AddColtoStatements < ActiveRecord::Migration[7.0]
  def change
    add_column :statements, :invoiced_at, :datetime
  end
end
