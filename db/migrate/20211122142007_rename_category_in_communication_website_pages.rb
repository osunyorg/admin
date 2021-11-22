class RenameCategoryInCommunicationWebsitePages < ActiveRecord::Migration[6.1]
  def change
    rename_column :communication_website_pages, :category_id, :related_category_id
  end
end
