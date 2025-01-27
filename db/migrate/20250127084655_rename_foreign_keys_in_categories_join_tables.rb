class RenameForeignKeysInCategoriesJoinTables < ActiveRecord::Migration[7.2]
  def change
    rename_column :communication_website_pages_categories, :communication_website_page_id, :page_id
    rename_column :communication_website_pages_categories, :communication_website_page_category_id, :category_id

    rename_column :communication_website_categories_posts, :communication_website_post_id, :post_id
    rename_column :communication_website_categories_posts, :communication_website_category_id, :category_id

    rename_column :communication_website_agenda_events_categories, :communication_website_agenda_event_id, :event_id
    rename_column :communication_website_agenda_events_categories, :communication_website_agenda_category_id, :category_id

    rename_column :communication_website_portfolio_categories_projects, :communication_website_portfolio_project_id, :project_id
    rename_column :communication_website_portfolio_categories_projects, :communication_website_portfolio_category_id, :category_id

    rename_column :education_program_categories_programs, :education_program_id, :program_id
    rename_column :education_program_categories_programs, :education_program_category_id, :category_id
  end
end
