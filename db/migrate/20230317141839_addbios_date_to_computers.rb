class AddbiosDateToComputers < ActiveRecord::Migration[7.0]
  def change
    add_column :computers, :bios_released_on, :datetime

    create_table :computer_billings do |t|
      t.monetize :cost_per_job
      t.datetime :billed_on

      t.references :account, null: false, foreign_key: true
      t.timestamps
    end

  end
end
