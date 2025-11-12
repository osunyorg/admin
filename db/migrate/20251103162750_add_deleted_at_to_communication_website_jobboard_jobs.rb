class AddDeletedAtToCommunicationWebsiteJobboardJobs < ActiveRecord::Migration[8.0]
  def change
    add_column :communication_website_jobboard_jobs, :deleted_at, :datetime
    add_column :communication_website_jobboard_job_localizations, :deleted_at, :datetime
  end
end
