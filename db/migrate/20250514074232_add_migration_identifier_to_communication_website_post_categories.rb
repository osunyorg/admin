class AddMigrationIdentifierToCommunicationWebsitePostCategories < ActiveRecord::Migration[8.0]
  def change
    add_column :communication_website_post_categories, :migration_identifier, :string
    add_column :communication_website_post_category_localizations, :migration_identifier, :string
  end
end
