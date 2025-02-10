class AddMigrationIdentifierToUniversityOrganizations < ActiveRecord::Migration[7.2]
  def change
    add_column :university_organizations, :migration_identifier, :string
    add_column :university_organization_localizations, :migration_identifier, :string
  end
end
