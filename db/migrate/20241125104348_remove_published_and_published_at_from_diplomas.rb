class RemovePublishedAndPublishedAtFromDiplomas < ActiveRecord::Migration[7.2]
  def up
    remove_column :education_diploma_localizations, :published
    remove_column :education_diploma_localizations, :published_at
  end

  def down
    add_column :education_diploma_localizations, :published, :boolean, default: false
    add_column :education_diploma_localizations, :published_at, :datetime
    Education::Diploma::Localization.reset_column_information
    Education::Diploma::Localization.update_all("published = TRUE, published_at = updated_at")
  end
end
