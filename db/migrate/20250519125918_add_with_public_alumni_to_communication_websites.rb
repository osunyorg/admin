class AddWithPublicAlumniToCommunicationWebsites < ActiveRecord::Migration[8.0]
  def change
    add_column :communication_websites, :feature_alumni, :boolean, default: false
  end
end
