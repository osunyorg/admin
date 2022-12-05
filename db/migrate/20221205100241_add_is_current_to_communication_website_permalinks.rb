class AddIsCurrentToCommunicationWebsitePermalinks < ActiveRecord::Migration[7.0]
  def change
    add_column :communication_website_permalinks, :is_current, :boolean, default: true
  end
end
