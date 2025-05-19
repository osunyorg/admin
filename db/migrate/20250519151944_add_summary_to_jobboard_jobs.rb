class AddSummaryToJobboardJobs < ActiveRecord::Migration[8.0]
  def change
    add_column :communication_website_jobboard_job_localizations, :summary, :text
  end
end
