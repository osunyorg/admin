class CreateJoinTablePortfolioCategoriesProjects < ActiveRecord::Migration[7.1]
  def change
    create_table "communication_website_portfolio_categories_projects", id: false, force: :cascade do |t|
      t.uuid "communication_website_portfolio_category_id", null: false
      t.uuid "communication_website_portfolio_project_id", null: false
      t.index ["communication_website_portfolio_category_id", "communication_website_portfolio_project_id"]
      t.index ["communication_website_portfolio_project_id", "communication_website_portfolio_category_id"]
    end
  end
end
