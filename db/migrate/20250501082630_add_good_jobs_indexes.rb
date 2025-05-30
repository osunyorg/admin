class AddGoodJobsIndexes < ActiveRecord::Migration[8.0]
  def change
    add_index :good_jobs, [:concurrency_key, :created_at], name: :index_good_jobs_on_concurrency_key_and_created_at
  end
end
