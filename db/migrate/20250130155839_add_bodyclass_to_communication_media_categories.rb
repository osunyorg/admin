class AddBodyclassToCommunicationMediaCategories < ActiveRecord::Migration[7.2]
  def change
    add_column :communication_media_categories, :bodyclass, :string
  end
end
