class RenameResearchUserBiography < ActiveRecord::Migration[6.1]
  def change
    rename_column :research_researchers, :biography, :old_biography
  end
end
