class AddInProductionAtToCommunicationWebsites < ActiveRecord::Migration[8.0]
  def change
    add_column :communication_websites, :in_production_at, :datetime
    Communication::Website.reset_column_information
    Communication::Website.in_production.find_each do |website|
      website.update_column :in_production_at, website.created_at
    end
  end
end
