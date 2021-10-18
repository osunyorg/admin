class RenameDescriptionToExcerpt < ActiveRecord::Migration[6.1]
  def change
    rename_column :communication_website_imported_posts, :description, :excerpt
  end
end
