class AddDefaultLanguageToCommunicationWebsites < ActiveRecord::Migration[7.0]
  def up
    add_reference :communication_websites, :default_language, null: true, foreign_key: { to_table: :languages }, type: :uuid

    Communication::Website.find_each do |website|
      next if website.languages.none?
      website.update_column :default_language_id, website.languages.first.id
    end
  end

  def down
    remove_reference :communication_websites, :default_language
  end
end
