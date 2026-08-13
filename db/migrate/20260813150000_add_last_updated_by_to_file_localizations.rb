class AddLastUpdatedByToFileLocalizations < ActiveRecord::Migration[8.1]
  def change
    add_reference :communication_file_localizations, :last_updated_by, foreign_key: { to_table: :users }, type: :uuid
  end
end
