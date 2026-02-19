class RemoveOriginalIdFromMenus < ActiveRecord::Migration[8.1]
  def change
    remove_reference :communication_website_menus, :original, foreign_key: {to_table: :communication_website_menus}, type: :uuid
  end
end
