class AddCtaToCommunicationPorfolioProjectLocalizations < ActiveRecord::Migration[7.2]
  def change
    add_column :communication_website_portfolio_project_localizations, :header_cta, :boolean, default: false
    add_column :communication_website_portfolio_project_localizations, :header_cta_label, :string
    add_column :communication_website_portfolio_project_localizations, :header_cta_url, :string
  end
end
