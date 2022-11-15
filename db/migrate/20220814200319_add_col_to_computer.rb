class AddColToComputer < ActiveRecord::Migration[7.0]
  def change
    add_column :computers, :manufacturer, :string
    add_column :computers, :mb_serial_number, :string
    add_index :computers, :key

    create_table :jobs do |t|
      t.string :action
      t.datetime :started_at
      t.datetime :completed_at
      t.references :computer, null: false, foreign_key: true

      t.timestamps
    end

  end
end
