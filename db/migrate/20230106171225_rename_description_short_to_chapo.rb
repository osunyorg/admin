class RenameDescriptionShortToChapo < ActiveRecord::Migration[7.0]
  def change
    rename_column :communication_website_pages, :description_short, :chapo
    rename_column :communication_website_posts, :description_short, :chapo
    rename_column :education_diplomas, :description_short, :chapo
    rename_column :education_programs, :description_short, :chapo
    rename_column :university_organizations, :description_short, :chapo
    rename_column :university_people, :description_short, :chapo
  end
end
