class AddPublishedToUniversityPersonLocalization < ActiveRecord::Migration[8.0]
  def change
    add_column :university_person_localizations, :published, :boolean, default: true
    add_column :university_person_localizations, :published_at, :datetime

    University::Person::Localization.reset_column_information
    University::Person::Localization.update_all("published_at = created_at")
  end
end
