class AddProgramToCommunicationWebsitePageCategories < ActiveRecord::Migration[7.2]
  def change
    add_reference :communication_website_page_categories, :program, foreign_key: { to_table: :education_programs }, type: :uuid
    add_column :communication_website_page_categories, :is_programs_root, :boolean, default: false
  end
end
