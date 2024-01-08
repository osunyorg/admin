class AddDefaultTimeZoneToCommunicationWebsites < ActiveRecord::Migration[7.1]
  def change
    add_column :communication_websites, :default_time_zone, :string
    Communication::Website.reset_column_information
    Communication::Website.update_all(default_time_zone: "Europe/Paris")
  end
end
