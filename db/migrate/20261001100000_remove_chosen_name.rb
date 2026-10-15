class RemoveChosenName < ActiveRecord::Migration[8.1]
  def change
    remove_column :users, :chosen_name, :string
    remove_column :university_person_localizations, :chosen_name, :string
  end
end
