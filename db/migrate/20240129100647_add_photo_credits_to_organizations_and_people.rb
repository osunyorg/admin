class AddPhotoCreditsToOrganizationsAndPeople < ActiveRecord::Migration[7.1]
  def change
    add_column :university_people, :picture_credit, :text
    add_column :university_organizations, :logo_credit, :text
  end
end
