class AddPublicationToCommunicationMediaLocalizations < ActiveRecord::Migration[8.1]
  def change
    add_column :communication_media_localizations, :published, :boolean, default: false
    add_column :communication_media_localizations, :published_at, :datetime

    Communication::Media::Localization.reset_column_information
    Communication::Media::Localization.update_all(published: true, published_at: Time.current)
  end
end
