class PutAuthorsAndCategoriesUnderPosts < ActiveRecord::Migration[7.1]
  def change
    rename_table :communication_website_categories, :communication_website_post_categories
  end
end
