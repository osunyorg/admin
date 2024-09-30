class RemoveCommunicationWebsitePortfolioProjectOldI18n < ActiveRecord::Migration[7.1]
  def change
    remove_column :communication_website_portfolio_projects, :original_id
    remove_column :communication_website_portfolio_projects, :language_id
    remove_column :communication_website_portfolio_projects, :featured_image_alt
    remove_column :communication_website_portfolio_projects, :featured_image_credit
    remove_column :communication_website_portfolio_projects, :meta_description
    remove_column :communication_website_portfolio_projects, :published
    remove_column :communication_website_portfolio_projects, :slug
    remove_column :communication_website_portfolio_projects, :summary
    remove_column :communication_website_portfolio_projects, :title

  end
end
