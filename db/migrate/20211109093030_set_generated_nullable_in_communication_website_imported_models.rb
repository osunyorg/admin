class SetGeneratedNullableInCommunicationWebsiteImportedModels < ActiveRecord::Migration[6.1]
  def change
    change_column_null :communication_website_imported_authors,     :author_id,   true
    change_column_null :communication_website_imported_categories,  :category_id, true
    change_column_null :communication_website_imported_pages,       :page_id,     true
    change_column_null :communication_website_imported_posts,       :post_id,     true
  end
end
