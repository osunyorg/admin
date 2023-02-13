class AddHalIdToUniversityPersons < ActiveRecord::Migration[7.0]
  def change
    add_column :university_people, :hal_person_identifier, :string
  end
end
