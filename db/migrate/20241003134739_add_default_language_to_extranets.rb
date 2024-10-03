class AddDefaultLanguageToExtranets < ActiveRecord::Migration[7.1]
   def up
    add_reference :communication_extranets, :default_language, null: true, foreign_key: { to_table: :languages }, type: :uuid
    Communication::Extranet.reset_column_information
    Communication::Extranet.find_each do |extranet|
      next if extranet.languages.none?
      extranet.update_column :default_language_id, extranet.languages.first.id
    end
  end

  def down
    remove_reference :communication_extranets, :default_language
  end
end
