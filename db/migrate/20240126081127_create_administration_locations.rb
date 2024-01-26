class CreateAdministrationLocations < ActiveRecord::Migration[7.1]
  def change
    create_table :administration_locations, id: :uuid do |t|
      t.references :university, null: false, foreign_key: true, type: :uuid
      t.string :name
      t.text :summary
      t.string :address
      t.string :zipcode
      t.string :city
      t.string :country
      t.float :latitude
      t.float :longitude
      t.string :phone
      t.string :url

      t.timestamps
    end
  end
end
