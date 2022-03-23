class AddAlumnusToUniversityPerson < ActiveRecord::Migration[6.1]
  def change
    add_column :university_people, :is_alumnus, :bool, default: false
  end
end
