class RemoveMetadescSummaryFromEducationSchoolLocalizations < ActiveRecord::Migration[7.1]
  def change
    remove_column :education_school_localizations, :meta_description, :string
    remove_column :education_school_localizations, :summary, :text
  end
end
