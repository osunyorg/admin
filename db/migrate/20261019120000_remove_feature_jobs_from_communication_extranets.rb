class RemoveFeatureJobsFromCommunicationExtranets < ActiveRecord::Migration[8.1]
  def change
    remove_column :communication_extranets, :feature_jobs, :boolean, default: false
  end
end
