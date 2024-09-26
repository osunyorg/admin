class RemoveEducationSchoolOldI18n < ActiveRecord::Migration[7.1]
  def change
    remove_colum :education_schools, :original_id
    remove_colum :education_schools, :language_id
    remove_colum :education_schools, :name
    remove_colum :education_schools, :url
    
  end
end
