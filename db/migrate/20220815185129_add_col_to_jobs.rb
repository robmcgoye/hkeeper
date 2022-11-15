class AddColToJobs < ActiveRecord::Migration[7.0]
  def change
    add_column :jobs, :notes, :text
    add_column :jobs, :recur, :boolean
    add_column :jobs, :days_to_recur, :integer
    add_column :jobs, :times_executed, :integer
    
  end
end
