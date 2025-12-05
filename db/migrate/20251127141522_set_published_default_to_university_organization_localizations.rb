class SetPublishedDefaultToUniversityOrganizationLocalizations < ActiveRecord::Migration[8.0]
  def change
    change_column_default :university_organization_localizations, :published, from: false, to: true
  end
end
