class RenameIsAdministrationInUniversityPeople < ActiveRecord::Migration[6.1]
  def change
    rename_column :university_people, :is_administrative, :is_administration
  end
end
