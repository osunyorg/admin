class RemoveCommunicationWebsitePageOldI18n < ActiveRecord::Migration[7.1]
  def change
    remove_column :communication_website_pages, :original_id
    remove_column :communication_website_pages, :language_id
    remove_column :communication_website_pages, :breadcrumb_title
    remove_column :communication_website_pages, :featured_image_alt
    remove_column :communication_website_pages, :featured_image_credit
    remove_column :communication_website_pages, :header_cta
    remove_column :communication_website_pages, :header_cta_label
    remove_column :communication_website_pages, :header_cta_url
    remove_column :communication_website_pages, :header_text
    remove_column :communication_website_pages, :meta_description
    remove_column :communication_website_pages, :published
    remove_column :communication_website_pages, :published_at
    remove_column :communication_website_pages, :slug
    remove_column :communication_website_pages, :summary
    remove_column :communication_website_pages, :text
    remove_column :communication_website_pages, :title

  end
end
