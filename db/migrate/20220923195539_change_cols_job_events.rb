class ChangeColsJobEvents < ActiveRecord::Migration[7.0]
  def change
    remove_column :job_events, :started_at
    remove_column :job_events, :completed_at
    rename_column :job_events, :times_executed, :status
  end
end
