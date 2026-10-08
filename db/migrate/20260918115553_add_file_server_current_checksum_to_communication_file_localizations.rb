class AddFileServerCurrentChecksumToCommunicationFileLocalizations < ActiveRecord::Migration[8.1]
  def change
    add_column :communication_file_localizations, :file_server_current_checksum, :string
  end
end
