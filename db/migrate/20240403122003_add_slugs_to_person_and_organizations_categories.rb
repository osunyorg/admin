class AddSlugsToPersonAndOrganizationsCategories < ActiveRecord::Migration[7.1]
  def change
    add_column :university_organization_categories, :slug, :string
    add_column :university_person_categories, :slug, :string
  end
end
