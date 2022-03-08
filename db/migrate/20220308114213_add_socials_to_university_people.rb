class AddSocialsToUniversityPeople < ActiveRecord::Migration[6.1]
  def change
    add_column :university_people, :url, :string
    add_column :university_people, :twitter, :string
    add_column :university_people, :linkedin, :string
  end
end
