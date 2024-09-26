class RemoveCommunicationExtranetDocumentOldI18n < ActiveRecord::Migration[7.1]
  def change
    remove_column :communication_extranet_documents, :name
    remove_column :communication_extranet_documents, :published
    remove_column :communication_extranet_documents, :published_at

  end
end
