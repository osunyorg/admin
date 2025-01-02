class RemoveSlugFromUniversityOrganizations < ActiveRecord::Migration[7.2]
  def change
    remove_column :university_organizations, :slug, :string
  end
end
