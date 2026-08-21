class MakeCommunicationMediasParanoid < ActiveRecord::Migration[8.1]
  def change
    add_column :communication_medias, :deleted_at, :datetime
    add_index :communication_medias, :deleted_at
    add_column :communication_media_localizations, :deleted_at, :datetime
    add_index :communication_media_localizations, :deleted_at
  end
end
