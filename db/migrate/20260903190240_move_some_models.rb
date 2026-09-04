class MoveSomeModels < ActiveRecord::Migration[8.1]
  def change
    rename_table :tasks_counts, :server_tasks_counts
    rename_table :emergency_messages, :server_emergency_messages
  end
end
