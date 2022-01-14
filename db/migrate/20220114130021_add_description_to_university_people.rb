class AddDescriptionToUniversityPeople < ActiveRecord::Migration[6.1]
  def change
    add_column :university_people, :description, :text
  end
end
