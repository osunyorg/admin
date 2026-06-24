class CreateTasksCount < ActiveRecord::Migration[8.1]
  def change
    create_table :tasks_counts do |t|
      t.integer :tasks_pending, null: false, default: 0
      t.timestamps
    end
  end
end
