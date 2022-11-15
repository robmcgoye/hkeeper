class ChangeTableName < ActiveRecord::Migration[7.0]
  def change
    rename_table :job_histories, :job_events
  end
end
