class RemoveDelayedJob < ActiveRecord::Migration[7.1]
  def change
    drop_table :delayed_jobs
  end
end
