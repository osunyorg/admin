class AddFeaturedImageAltToCommunicationWebsiteCategory < ActiveRecord::Migration[6.1]
  def change
    add_column :communication_website_categories, :featured_image_alt, :string
  end
end
