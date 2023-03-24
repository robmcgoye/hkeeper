class AddColsToComputerBiller < ActiveRecord::Migration[7.0]
  def change
    add_column :computers, :description, :string
    add_column :billers, :name, :string
  end
end
