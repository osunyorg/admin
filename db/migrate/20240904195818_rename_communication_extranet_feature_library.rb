class RenameCommunicationExtranetFeatureLibrary < ActiveRecord::Migration[7.1]
  def change
    rename_column :communication_extranets, :feature_library, :feature_documents
  end
end
