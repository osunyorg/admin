class CreateCommunicationMediasCollections < ActiveRecord::Migration[7.2]
  def change
    create_table :communication_media_collections, id: :uuid do |t|
      t.references :university, null: false, foreign_key: true, type: :uuid
      t.timestamps
    end

    create_table :communication_media_collection_localizations, id: :uuid do |t|
      t.string :name
      t.text :featured_image_alt
      t.text :featured_image_credit
      t.references :language, null: false, foreign_key: true, type: :uuid
      t.references :about, null: false, foreign_key: {to_table: :communication_media_collections}, type: :uuid
      t.references :university, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end

    add_reference :communication_medias, :communication_media_collection, foreign_key: true, type: :uuid
  end
end
