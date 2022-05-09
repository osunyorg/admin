class AddCreditToCommunicationWebsitePosts < ActiveRecord::Migration[6.1]
  def change
    add_column :communication_website_posts, :featured_image_credit, :text
  end
end
