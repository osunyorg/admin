class AddNameToUniversityPersons < ActiveRecord::Migration[6.1]
  def change
    add_column :university_people, :name, :string
  end
end
