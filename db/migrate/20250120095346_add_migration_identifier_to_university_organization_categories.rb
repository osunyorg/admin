class AddMigrationIdentifierToUniversityOrganizationCategories < ActiveRecord::Migration[7.2]
  def change
    add_column :university_organization_categories, :migration_identifier, :string
    add_column :university_organization_category_localizations, :migration_identifier, :string
  end
end
