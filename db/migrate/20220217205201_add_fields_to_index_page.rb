class AddFieldsToIndexPage < ActiveRecord::Migration[6.1]
  def change
    add_column :communication_website_index_pages, :breadcrumb_title, :string
    add_column :communication_website_index_pages, :header_text, :string
  end
end
