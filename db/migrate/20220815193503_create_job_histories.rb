class CreateJobHistories < ActiveRecord::Migration[7.0]
  def change

    rename_column :jobs, :started_at, :execute_after
    remove_column :jobs, :completed_at
    remove_column :jobs, :times_executed
    remove_column :jobs, :recur
    add_column :jobs, :status, :integer

    create_table :job_histories do |t|
      t.datetime :started_at
      t.datetime :completed_at
      t.text :notes
      t.references :job, null: false, foreign_key: true
      t.integer :times_executed
      t.timestamps
    end
  end
end
