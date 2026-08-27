class AddPublicationToCommunicationMediaLocalizations < ActiveRecord::Migration[8.1]
  def change
    add_column :communication_media_localizations, :published, :boolean, default: false
    add_column :communication_media_localizations, :published_at, :datetime
  end
end
