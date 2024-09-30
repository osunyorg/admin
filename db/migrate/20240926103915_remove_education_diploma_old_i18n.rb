class RemoveEducationDiplomaOldI18n < ActiveRecord::Migration[7.1]
  def change
    remove_column :education_diplomas, :original_id
    remove_column :education_diplomas, :language_id
    remove_column :education_diplomas, :duration
    remove_column :education_diplomas, :name
    remove_column :education_diplomas, :short_name
    remove_column :education_diplomas, :slug
    remove_column :education_diplomas, :summary


  end
end
