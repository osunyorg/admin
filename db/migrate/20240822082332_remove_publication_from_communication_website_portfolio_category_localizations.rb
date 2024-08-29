class RemovePublicationFromCommunicationWebsitePortfolioCategoryLocalizations < ActiveRecord::Migration[7.1]
  def change
    remove_column :communication_website_portfolio_category_localizations, :published, :boolean, default: false
    remove_column :communication_website_portfolio_category_localizations, :published_at, :datetime
  end
end
