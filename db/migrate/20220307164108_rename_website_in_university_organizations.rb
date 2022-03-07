class RenameWebsiteInUniversityOrganizations < ActiveRecord::Migration[6.1]
  def change
    rename_column :university_organizations, :website, :url
  end
end
