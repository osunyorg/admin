class RemoveCommunicationWebsitePortfolioCategoryOldI18n < ActiveRecord::Migration[7.1]
  def change
    remove_column :communication_website_portfolio_categories, :original_id
    remove_column :communication_website_portfolio_categories, :language_id
    remove_column :communication_website_portfolio_categories, :featured_image_alt
    remove_column :communication_website_portfolio_categories, :featured_image_credit
    remove_column :communication_website_portfolio_categories, :meta_description
    remove_column :communication_website_portfolio_categories, :name
    remove_column :communication_website_portfolio_categories, :path
    remove_column :communication_website_portfolio_categories, :slug
    remove_column :communication_website_portfolio_categories, :summary
  end
end
