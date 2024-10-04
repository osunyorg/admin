class AddDefaultLanguageToExtranets < ActiveRecord::Migration[7.1]
   def up
    add_reference :communication_extranets, :default_language, null: true, foreign_key: { to_table: :languages }, type: :uuid
    Communication::Extranet.reset_column_information
    Communication::Extranet.find_each do |extranet|
      extranet.update_column :default_language_id, extranet.languages.first.id
    end
    change_column_null :communication_extranets, :default_language_id, false
  end

  def down
    remove_reference :communication_extranets, :default_language
  end
end
