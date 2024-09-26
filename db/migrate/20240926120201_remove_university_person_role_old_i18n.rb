class RemoveUniversityPersonRoleOldI18n < ActiveRecord::Migration[7.1]
  def change
    remove_colum :university_roles, :original_id
    remove_colum :university_roles, :language_id
    remove_colum :university_roles, :description
  end
end
