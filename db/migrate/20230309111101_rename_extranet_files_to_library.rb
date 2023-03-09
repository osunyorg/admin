class RenameExtranetFilesToLibrary < ActiveRecord::Migration[7.0]
  def change
    rename_column :communication_extranets, :feature_files, :feature_library
    rename_table :communication_extranet_files, :communication_extranet_documents
  end
end
