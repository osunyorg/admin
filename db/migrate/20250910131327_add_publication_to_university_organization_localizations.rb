class AddPublicationToUniversityOrganizationLocalizations < ActiveRecord::Migration[8.0]
  def change
    add_column :university_organization_localizations, :published, :boolean, default: false
    add_column :university_organization_localizations, :published_at, :datetime
    
    University::Organization.find_each do |organization|
      next unless organization.active
      organization.localizations.each do |l10n|
        l10n.update_columns(
          published: organization.active,
          published_at: organization.updated_at
        )
      end
    end
  end
end
