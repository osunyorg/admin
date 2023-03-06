class AddGeolocationToUniversityOrganizations < ActiveRecord::Migration[7.0]
  def change
    add_column :university_organizations, :latitude, :float
    add_column :university_organizations, :longitude, :float
  end
end
