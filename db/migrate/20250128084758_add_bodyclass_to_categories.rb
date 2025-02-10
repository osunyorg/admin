class AddBodyclassToCategories < ActiveRecord::Migration[7.2]
  def change
    add_column :communication_website_agenda_categories, :bodyclass, :string
    add_column :communication_website_page_categories, :bodyclass, :string
    add_column :communication_website_portfolio_categories, :bodyclass, :string
    add_column :communication_website_post_categories, :bodyclass, :string
    add_column :education_program_categories, :bodyclass, :string
    add_column :university_organization_categories, :bodyclass, :string
    add_column :university_person_categories, :bodyclass, :string
  end
end
