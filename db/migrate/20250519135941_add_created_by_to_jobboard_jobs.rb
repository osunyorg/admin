class AddCreatedByToJobboardJobs < ActiveRecord::Migration[8.0]
  def change
    add_reference :communication_website_jobboard_jobs, :created_by, foreign_key: { to_table: :users }, type: :uuid
    
  end
end
