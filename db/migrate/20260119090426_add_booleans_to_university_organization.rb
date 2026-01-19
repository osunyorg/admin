class AddBooleansToUniversityOrganization < ActiveRecord::Migration[8.0]
  def change
    add_column :university_organizations, :is_school, :boolean, default: false
    add_column :university_organizations, :is_location, :boolean, default: false
    add_column :university_organizations, :is_laboratory, :boolean, default: false
  end
end
