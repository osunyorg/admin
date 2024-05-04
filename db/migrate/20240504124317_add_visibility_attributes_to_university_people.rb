class AddVisibilityAttributesToUniversityPeople < ActiveRecord::Migration[7.1]
  def change
    add_column :university_people, :address_visibility, :integer, default: 0
    add_column :university_people, :linkedin_visibility, :integer, default: 0
    add_column :university_people, :twitter_visibility, :integer, default: 0
    add_column :university_people, :mastodon_visibility, :integer, default: 0
    add_column :university_people, :phone_mobile_visibility, :integer, default: 0
    add_column :university_people, :phone_professional_visibility, :integer, default: 0
    add_column :university_people, :phone_personal_visibility, :integer, default: 0
    add_column :university_people, :email_visibility, :integer, default: 0
  end
end
