class AddChosenNameToUniversityPersonLocalizations < ActiveRecord::Migration[8.1]
  def change
    add_column :university_person_localizations, :chosen_name, :string
  end
end
