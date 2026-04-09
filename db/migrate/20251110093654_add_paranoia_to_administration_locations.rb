class AddParanoiaToAdministrationLocations < ActiveRecord::Migration[8.0]
  def change
    add_column :administration_locations, :deleted_at, :datetime
    add_column :administration_location_localizations, :deleted_at, :datetime
  end
end
