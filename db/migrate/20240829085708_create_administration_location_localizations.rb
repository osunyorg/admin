class CreateAdministrationLocationLocalizations < ActiveRecord::Migration[7.1]
  def up
    change_column_null :administration_locations, :language_id, true

    create_table :administration_location_localizations, id: :uuid do |t|
      t.string :address_additional
      t.string :address_name
      t.string :featured_image_alt
      t.text :featured_image_credit
      t.string :meta_description
      t.string :slug
      t.text :summary
      t.string :name
      t.string :url

      t.references :about, foreign_key: { to_table: :administration_locations }, type: :uuid
      t.references :language, foreign_key: true, type: :uuid
      t.references :university, foreign_key: true, type: :uuid

      t.timestamps
    end
  end

  def down
    drop_table :administration_location_localizations
  end
end
