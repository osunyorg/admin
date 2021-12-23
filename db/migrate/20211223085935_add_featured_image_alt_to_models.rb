class AddFeaturedImageAltToModels < ActiveRecord::Migration[6.1]
  def change
    add_column :communication_website_homes, :featured_image_alt, :string
    add_column :communication_website_pages, :featured_image_alt, :string
    add_column :communication_website_posts, :featured_image_alt, :string
    add_column :education_programs, :featured_image_alt, :string
    add_column :research_journal_volumes, :cover_alt, :string
  end
end
