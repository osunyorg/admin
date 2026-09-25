class AddPublicationInfosToFileLocalizations < ActiveRecord::Migration[8.1]
  def change
    add_column :communication_file_localizations, :published, :boolean, default: false
    add_column :communication_file_localizations, :published_at, :datetime
    add_reference :communication_file_localizations, :published_by, foreign_key: { to_table: :users }, type: :uuid
  end
end
