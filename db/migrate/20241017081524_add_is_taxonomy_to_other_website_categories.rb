class AddIsTaxonomyToOtherWebsiteCategories < ActiveRecord::Migration[7.1]
  def change
    add_column :communication_website_agenda_categories, :is_taxonomy, :boolean, default: false
    add_column :communication_website_post_categories, :is_taxonomy, :boolean, default: false
  end
end
