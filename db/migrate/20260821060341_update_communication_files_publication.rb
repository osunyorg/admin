class UpdateCommunicationFilesPublication < ActiveRecord::Migration[8.1]
  def change
    rename_column :communication_file_localizations, :last_updated_by_id, :updated_by_id
    remove_reference :communication_file_localizations, :published_by
  end
end
