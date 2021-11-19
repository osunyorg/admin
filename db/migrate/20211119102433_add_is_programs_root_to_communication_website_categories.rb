class AddIsProgramsRootToCommunicationWebsiteCategories < ActiveRecord::Migration[6.1]
  def change
    add_column :communication_website_categories, :is_programs_root, :boolean, default: false
  end
end
