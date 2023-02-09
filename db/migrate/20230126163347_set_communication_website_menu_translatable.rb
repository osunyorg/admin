class SetCommunicationWebsiteMenuTranslatable < ActiveRecord::Migration[7.0]
  def change
    add_reference :communication_website_menus, :original, foreign_key: {to_table: :communication_website_menus}, type: :uuid
    add_reference :communication_website_menus, :language, foreign_key: true, type: :uuid

    Communication::Website.find_each do |website|
      website.menus.where(language_id: nil).update_all(language_id: website.default_language_id)
    end

    change_column_null :communication_website_menus, :language_id, false
  end
end
