class RenameDescriptionToMetaDescription < ActiveRecord::Migration[7.0]
  def change
    rename_column :communication_website_categories, :description, :meta_description
    rename_column :communication_website_pages, :description, :meta_description
    rename_column :communication_website_posts, :description, :meta_description
    rename_column :education_programs, :description, :meta_description
    rename_column :research_journals, :description, :meta_description
    rename_column :research_journal_papers, :description, :meta_description
    rename_column :research_journal_volumes, :description, :meta_description
    rename_column :research_laboratory_axes, :description, :meta_description
    rename_column :university_organizations, :description, :meta_description
    rename_column :university_people, :description, :meta_description
  end
end
