class RemoveIsAuthorFromUniversityPeople < ActiveRecord::Migration[6.1]
  def change
    remove_column :university_people, :is_author, :boolean
  end
end
