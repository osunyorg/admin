class RemoveCommunicationExtranetDocumentCategoryOldI18n < ActiveRecord::Migration[7.1]
  def change
    remove_colum :communication_extranet_document_categories, :slug
    remove_colum :communication_extranet_document_categories, :name

  end
end
