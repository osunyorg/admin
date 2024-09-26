class RemoveEducationSchoolOldI18n < ActiveRecord::Migration[7.1]
  def change
    remove_column :education_schools, :original_id
    remove_column :education_schools, :language_id
    remove_column :education_schools, :name
    remove_column :education_schools, :url

  end
end
