class AddDataToImportedCategory < ActiveRecord::Migration[6.1]
  def change
    add_column :communication_website_imported_categories, :data, :jsonb
  end
end
