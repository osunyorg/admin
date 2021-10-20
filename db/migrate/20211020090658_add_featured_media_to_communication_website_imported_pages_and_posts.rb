class AddFeaturedMediaToCommunicationWebsiteImportedPagesAndPosts < ActiveRecord::Migration[6.1]
  def change
    add_reference :communication_website_imported_pages,
                  :featured_medium,
                  foreign_key: { to_table: :communication_website_imported_media },
                  type: :uuid,
                  index: { name: 'idx_communication_website_imported_pages_on_featured_medium_id' }
    add_reference :communication_website_imported_posts,
                  :featured_medium,
                  foreign_key: { to_table: :communication_website_imported_media },
                  type: :uuid,
                  index: { name: 'idx_communication_website_imported_posts_on_featured_medium_id' }
  end
end
