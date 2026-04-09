class AddSubtitleToCommunicationWebsitesPageLocalizations < ActiveRecord::Migration[8.0]
  def change
    add_column :communication_website_page_localizations, :subtitle, :string
  end
end
