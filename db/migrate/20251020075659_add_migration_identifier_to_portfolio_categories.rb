class AddMigrationIdentifierToPortfolioCategories < ActiveRecord::Migration[8.0]
  def change
    add_column :communication_website_portfolio_categories, :migration_identifier, :string
    add_column :communication_website_portfolio_category_localizations, :migration_identifier, :string
  end
end
