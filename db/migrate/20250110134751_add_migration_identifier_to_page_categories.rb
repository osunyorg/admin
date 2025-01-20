class AddMigrationIdentifierToPageCategories < ActiveRecord::Migration[7.2]
  def change
    add_column :communication_website_page_categories, :migration_identifier, :string
    add_column :communication_website_page_category_localizations, :migration_identifier, :string
  end
end
