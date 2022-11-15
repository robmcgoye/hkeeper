class AddColsToComputer < ActiveRecord::Migration[7.0]
  def change
    add_column :computers, :notes, :text
    add_column :computers, :last_contacted_at, :datetime

  end
end
