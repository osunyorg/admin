class AddProgramIdToCommunicationWebsitePortfolioCategories < ActiveRecord::Migration[7.1]
  def change
    add_reference :communication_website_portfolio_categories, :program, foreign_key: { to_table: :education_programs }, type: :uuid
  end
end
