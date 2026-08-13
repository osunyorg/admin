class AddExtensionToCommunicationFileLocalizations < ActiveRecord::Migration[8.1]
  def change
    add_column :communication_file_localizations, :original_extension, :string, default: ''r
  end
end
