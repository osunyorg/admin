class AddSubtitleToCommunicationWebsitePostLocalizations < ActiveRecord::Migration[7.1]
  def change
    add_column :communication_website_post_localizations, :subtitle, :string
  end
end
