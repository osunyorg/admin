class AddFeatureUnpublicationDateToCommunicationWebsites < ActiveRecord::Migration[8.1]
  def change
    add_column :communication_websites, :feature_unpublication_date, :boolean, default: false
  end
end
