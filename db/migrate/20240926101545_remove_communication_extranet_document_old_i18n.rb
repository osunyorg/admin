class RemoveCommunicationExtranetDocumentOldI18n < ActiveRecord::Migration[7.1]
  def change
    remove_colum :communication_extranet_documents, :name
    remove_colum :communication_extranet_documents, :published
    remove_colum :communication_extranet_documents, :published_at

  end
end
