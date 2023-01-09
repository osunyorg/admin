class RenameCategoriesTextToSummary < ActiveRecord::Migration[7.0]
  def change
    rename_column :communication_website_categories, :text, :summary
  end
end
