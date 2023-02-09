class AddNullFalseToCommunicationWebsitePageLanguageId < ActiveRecord::Migration[7.0]
  def change
    change_column :communication_website_pages, :language_id, :uuid, null: false
  end
end
