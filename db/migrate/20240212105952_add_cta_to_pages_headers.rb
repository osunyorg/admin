class AddCtaToPagesHeaders < ActiveRecord::Migration[7.1]
  def change
    add_column :communication_website_pages, :header_cta, :boolean, default: false
    add_column :communication_website_pages, :header_cta_url, :string
    add_column :communication_website_pages, :header_cta_label, :string
  end
end
