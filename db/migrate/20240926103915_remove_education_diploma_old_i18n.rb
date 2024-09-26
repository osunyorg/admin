class RemoveEducationDiplomaOldI18n < ActiveRecord::Migration[7.1]
  def change
    remove_colum :education_diplomas, :original_id
    remove_colum :education_diplomas, :language_id
    remove_colum :education_diplomas, :duration
    remove_colum :education_diplomas, :name
    remove_colum :education_diplomas, :short_name
    remove_colum :education_diplomas, :slug
    remove_colum :education_diplomas, :summary
    
    
  end
end
