class AddPositionInTree < ActiveRecord::Migration[8.0]
  def change
    add_column :communication_media_categories, :position_in_tree, :integer
    add_column :communication_website_agenda_categories, :position_in_tree, :integer
    add_column :communication_website_menu_items, :position_in_tree, :integer
    add_column :communication_website_page_categories, :position_in_tree, :integer
    add_column :communication_website_pages, :position_in_tree, :integer
    add_column :communication_website_portfolio_categories, :position_in_tree, :integer
    add_column :communication_website_post_categories, :position_in_tree, :integer
    add_column :education_program_categories, :position_in_tree, :integer
    add_column :university_organization_categories, :position_in_tree, :integer
    add_column :university_person_categories, :position_in_tree, :integer
  end
end
