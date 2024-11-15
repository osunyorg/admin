class AddIsTaxonomyToOrgaAndPersonCategories < ActiveRecord::Migration[7.2]
  def change
    add_column :university_organization_categories, :is_taxonomy, :boolean, default: false
    add_column :university_person_categories, :is_taxonomy, :boolean, default: false
  end
end
