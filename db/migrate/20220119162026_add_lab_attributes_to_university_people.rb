class AddLabAttributesToUniversityPeople < ActiveRecord::Migration[6.1]
  def change
    add_column :university_people, :habilitation, :boolean, default: false
    add_column :university_people, :tenure, :boolean, default: false
  end
end
