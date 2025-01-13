class AddFullWidthToCommunicationWebsitePortfolioProject < ActiveRecord::Migration[7.2]
  def change
    add_column :communication_website_portfolio_projects, :full_width, :boolean, default: true
  end
end
