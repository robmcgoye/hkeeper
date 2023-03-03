class StatementsAddDueAt < ActiveRecord::Migration[7.0]
  def change
    add_column :statements, :due_at, :datetime
  end
end
