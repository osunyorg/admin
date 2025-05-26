class RemoveDescriptionInJobs < ActiveRecord::Migration[8.0]
  def change
    remove_column :communication_website_jobboard_job_localizations, :description
  end
end
