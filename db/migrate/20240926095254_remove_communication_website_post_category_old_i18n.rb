class RemoveCommunicationWebsitePostCategoryOldI18n < ActiveRecord::Migration[7.1]
  def change
    remove_colum :communication_website_post_categories, :original_id
    remove_colum :communication_website_post_categories, :language_id
    remove_colum :communication_website_post_categories, :featured_image_alt
    remove_colum :communication_website_post_categories, :featured_image_credit
    remove_colum :communication_website_post_categories, :name
    remove_colum :communication_website_post_categories, :meta_description
    remove_colum :communication_website_post_categories, :slug
    remove_colum :communication_website_post_categories, :path
    remove_colum :communication_website_post_categories, :summary
  end
end
