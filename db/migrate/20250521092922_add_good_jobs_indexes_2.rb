class AddGoodJobsIndexes2 < ActiveRecord::Migration[8.0]
  def change
    add_index :good_jobs, :finished_at
  end
end
