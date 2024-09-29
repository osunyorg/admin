class AddLanguageToImports < ActiveRecord::Migration[7.1]
  def up
    add_reference :imports, :language, foreign_key: true, type: :uuid

    Import.reset_column_information
    Import.update_all("language_id = (SELECT default_language_id FROM universities WHERE id = university_id)")

    change_column_null :imports, :language_id, false
  end

  def down
    remove_reference :imports, :language
  end
end
