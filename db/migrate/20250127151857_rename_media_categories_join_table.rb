class RenameMediaCategoriesJoinTable < ActiveRecord::Migration[7.2]
  def change
    rename_column :communication_media_categories_medias, :communication_media_id, :media_id
    rename_column :communication_media_categories_medias, :communication_media_category_id, :category_id
  end
end
