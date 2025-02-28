class AddMigrationIdentifierToCommunicationWebsitePortfolioProjects < ActiveRecord::Migration[7.2]
  def change
    add_column :communication_website_portfolio_projects, :migration_identifier, :string
  end
end
