class AddSlugsToDocumentCategoriesAndKinds < ActiveRecord::Migration[7.0]
  def change
    add_column :communication_extranet_document_categories, :slug, :string
    add_column :communication_extranet_document_kinds, :slug, :string
  end
end
