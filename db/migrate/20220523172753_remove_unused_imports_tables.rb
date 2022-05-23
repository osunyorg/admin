class RemoveUnusedImportsTables < ActiveRecord::Migration[6.1]
  def change
    drop_table :university_organization_imports
    drop_table :university_person_alumnus_imports
  end
end
