class AddLanguageToImports < ActiveRecord::Migration[7.1]
  def change
    add_reference :imports, :language, foreign_key: true, type: :uuid
  end
end
