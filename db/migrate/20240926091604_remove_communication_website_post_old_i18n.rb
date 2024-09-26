class RemoveCommunicationWebsitePostOldI18n < ActiveRecord::Migration[7.1]
  def change
    remove_colum :communication_website_posts, :original_id
    remove_colum :communication_website_posts, :language_id
    remove_colum :communication_website_posts, :featured_image_alt
    remove_colum :communication_website_posts, :featured_image_credit
    remove_colum :communication_website_posts, :meta_description
    remove_colum :communication_website_posts, :pinned
    remove_colum :communication_website_posts, :published
    remove_colum :communication_website_posts, :published_at
    remove_colum :communication_website_posts, :slug
    remove_colum :communication_website_posts, :summary
    remove_colum :communication_website_posts, :text
    remove_colum :communication_website_posts, :title
  end
end
