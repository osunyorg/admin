class RemoveCommunicationWebsitePostCategoryOldI18n < ActiveRecord::Migration[7.1]
  def change
    remove_column :communication_website_post_categories, :original_id
    remove_column :communication_website_post_categories, :language_id
    remove_column :communication_website_post_categories, :featured_image_alt
    remove_column :communication_website_post_categories, :featured_image_credit
    remove_column :communication_website_post_categories, :name
    remove_column :communication_website_post_categories, :meta_description
    remove_column :communication_website_post_categories, :slug
    remove_column :communication_website_post_categories, :path
    remove_column :communication_website_post_categories, :summary
  end
end
