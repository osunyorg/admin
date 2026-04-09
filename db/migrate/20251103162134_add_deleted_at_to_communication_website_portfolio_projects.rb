class AddDeletedAtToCommunicationWebsitePortfolioProjects < ActiveRecord::Migration[8.0]
  def change
    add_column :communication_website_portfolio_projects, :deleted_at, :datetime
    add_column :communication_website_portfolio_project_localizations, :deleted_at, :datetime
  end
end
