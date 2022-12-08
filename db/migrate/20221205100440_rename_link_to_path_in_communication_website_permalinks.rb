class RenameLinkToPathInCommunicationWebsitePermalinks < ActiveRecord::Migration[7.0]
  def change
    rename_column :communication_website_permalinks, :link, :path
  end
end
