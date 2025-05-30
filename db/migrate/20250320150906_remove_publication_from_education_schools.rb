class RemovePublicationFromEducationSchools < ActiveRecord::Migration[7.2]
  def change
    remove_column :education_school_localizations, :published, :boolean, default: false
    remove_column :education_school_localizations, :published_at, :datetime
  end
end
