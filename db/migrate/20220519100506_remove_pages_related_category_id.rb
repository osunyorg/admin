class RemovePagesRelatedCategoryId < ActiveRecord::Migration[6.1]
  def change
    remove_column :communication_website_pages, :related_category_id
  end
end
