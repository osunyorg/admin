class AddFeaturedImageToUniversityPerson < ActiveRecord::Migration[7.2]
  def change
    add_column :university_person_localizations, :featured_image_alt, :text
    add_column :university_person_localizations, :featured_image_credit, :text
  end
end
