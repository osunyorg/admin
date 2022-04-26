class AddIsAuthorToUniversityPeople < ActiveRecord::Migration[6.1]
  def change
    add_column :university_people, :is_author, :boolean
  end
end
