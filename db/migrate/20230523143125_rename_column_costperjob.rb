class RenameColumnCostperjob < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :active, :boolean
    rename_column :computer_billings, :cost_per_job_cents, :cost_per_computer_cents
    rename_column :computer_billings, :cost_per_job_currency, :cost_per_computer_currency
  end
end
