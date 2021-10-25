class RenameTextForWebsitePages < ActiveRecord::Migration[6.1]
  def change
    rename_column :communication_website_pages, :text, :old_text

  end
end
