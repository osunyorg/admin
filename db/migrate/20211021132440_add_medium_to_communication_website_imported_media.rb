class AddMediumToCommunicationWebsiteImportedMedia < ActiveRecord::Migration[6.1]
  def change
    add_reference :communication_website_imported_media, :medium, foreign_key: { to_table: :communication_website_media }, type: :uuid
  end
end
