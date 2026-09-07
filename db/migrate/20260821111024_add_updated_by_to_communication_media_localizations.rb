class AddUpdatedByToCommunicationMediaLocalizations < ActiveRecord::Migration[8.1]
  def change
    add_reference :communication_media_localizations, :updated_by, foreign_key: { to_table: :users }, type: :uuid
  end
end
