class AddTwitterAndLinkedinToUniversityOrganizations < ActiveRecord::Migration[7.0]
  def change
    add_column :university_organizations, :twitter, :string
    add_column :university_organizations, :linkedin, :string
  end
end
