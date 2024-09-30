class RemoveUniversityPersonCatergoryOldI18n < ActiveRecord::Migration[7.1]
  def change
    remove_column :university_person_categories, :original_id
    remove_column :university_person_categories, :language_id
    remove_column :university_person_categories, :name
    remove_column :university_person_categories, :slug

  end
end
