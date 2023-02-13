class AddDefaultLanguageToUniversities < ActiveRecord::Migration[7.0]
  def change
    add_reference :universities, :default_language, foreign_key: { to_table: :languages }, type: :uuid

    University.reset_column_information
    language = Language.find_by(iso_code: 'fr')
    language ||= Language.find_by(iso_code: 'en')
    language ||= Language.first

    University.all.update_all(default_language_id: language.id) if University.all.any?

    change_column_null :universities, :default_language_id, false
  end
end
