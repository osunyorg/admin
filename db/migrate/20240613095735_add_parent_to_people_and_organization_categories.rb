class AddParentToPeopleAndOrganizationCategories < ActiveRecord::Migration[7.1]
  def change
    add_reference :university_person_categories, :parent, foreign_key: { to_table: :university_person_categories }, type: :uuid
    add_reference :university_organization_categories, :parent, foreign_key: { to_table: :university_organization_categories }, type: :uuid
  end
end
