class RemoveUnusedModels < ActiveRecord::Migration[6.1]
  def change
    remove_foreign_key :communication_website_imported_authors, column: :author_id
    add_foreign_key :communication_website_imported_authors, :administration_members, column: :author_id
    
    drop_table :education_teachers
    drop_table :research_researchers
    drop_table :communication_website_authors
  end
end
