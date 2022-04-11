class AddKindBreadcrumbTitleAndHeaderTextToPages < ActiveRecord::Migration[6.1]
  def change
    add_column :communication_website_pages, :breadcrumb_title, :string
    add_column :communication_website_pages, :header_text, :text
    add_column :communication_website_pages, :kind, :integer
  end
end
