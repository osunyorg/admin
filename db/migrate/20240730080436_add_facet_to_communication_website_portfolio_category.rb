class AddFacetToCommunicationWebsitePortfolioCategory < ActiveRecord::Migration[7.1]
  def change
    add_column :communication_website_portfolio_categories, :is_taxonomy, :boolean, default: false
  end
end
