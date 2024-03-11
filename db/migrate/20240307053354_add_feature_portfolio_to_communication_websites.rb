class AddFeaturePortfolioToCommunicationWebsites < ActiveRecord::Migration[7.1]
  def change
    add_column :communication_websites, :feature_portfolio, :boolean, default: false
  end
end
