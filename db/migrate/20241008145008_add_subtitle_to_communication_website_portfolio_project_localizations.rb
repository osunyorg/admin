class AddSubtitleToCommunicationWebsitePortfolioProjectLocalizations < ActiveRecord::Migration[7.1]
  def change
    add_column :communication_website_portfolio_project_localizations, :subtitle, :string
  end
end
