class AddMissionFeaturedImageCredits < ActiveRecord::Migration[6.1]
  def change
    add_column :communication_website_categories, :featured_image_credit, :text
    add_column :communication_website_pages, :featured_image_credit, :text
    add_column :education_programs, :featured_image_credit, :text
    add_column :research_journal_volumes, :featured_image_credit, :text

  end
end
