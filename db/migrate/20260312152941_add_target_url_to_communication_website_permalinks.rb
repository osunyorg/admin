class AddTargetUrlToCommunicationWebsitePermalinks < ActiveRecord::Migration[8.1]
  def change
    add_column :communication_website_permalinks, :target_url, :string
    change_column_null :communication_website_permalinks, :about_type, true
    change_column_null :communication_website_permalinks, :about_id, true
  end
end
