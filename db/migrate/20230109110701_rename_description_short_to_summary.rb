class RenameDescriptionShortToSummary < ActiveRecord::Migration[7.0]
  def change
    rename_column :communication_website_pages, :description_short, :summary
    rename_column :communication_website_posts, :description_short, :summary
    rename_column :education_diplomas, :description_short, :summary
    rename_column :education_programs, :description_short, :summary
    rename_column :university_organizations, :description_short, :summary
    rename_column :university_people, :description_short, :summary
  end
end
