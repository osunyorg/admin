class RemoveActiveFromUniversityOrganizations < ActiveRecord::Migration[8.0]
  def change
    remove_column :university_organizations, :active, :boolean, default: true
  end
end
