class AddSlugToUniversityOrganizations < ActiveRecord::Migration[6.1]
  def change
    add_column :university_organizations, :slug, :string
  end
end
