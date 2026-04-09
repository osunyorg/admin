class AddMigrationIdentifierToProjects < ActiveRecord::Migration[8.0]
  def change
    unless column_exists? :communication_website_portfolio_projects, :migration_identifier
      add_column :communication_website_portfolio_projects, :migration_identifier, :string
    end
  end
end
