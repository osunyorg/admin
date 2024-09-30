class RemoveCommunicationExtranetPostCategoryOldI18n < ActiveRecord::Migration[7.1]
  def change
    remove_column :communication_extranet_post_categories, :slug
    remove_column :communication_extranet_post_categories, :name
  end
end
