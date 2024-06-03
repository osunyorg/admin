class AddLockedByToCommunicationWebsites < ActiveRecord::Migration[7.1]
  def change
    add_column :communication_websites, :locked_by_job_id, :uuid
  end
end
