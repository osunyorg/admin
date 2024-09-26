class RemoveUniversityOrganizationCategoryOldI18n < ActiveRecord::Migration[7.1]
  def change
    remove_colum :university_organization_categories, :original_id
    remove_colum :university_organization_categories, :language_id
    remove_colum :university_organization_categories, :name
    remove_colum :university_organization_categories, :slug

  end
end
