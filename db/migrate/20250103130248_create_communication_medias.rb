class CreateCommunicationMedias < ActiveRecord::Migration[7.2]
  def change
    create_table :communication_medias, id: :uuid do |t|
      t.string :filename
      t.string :digest
      t.integer :origin, default: 1, null: false
      t.string :content_type
      t.bigint :byte_size
      t.boolean :variant, default: false
      t.references :blob, null: false, foreign_key: {to_table: :active_storage_blobs}, type: :uuid
      t.references :university, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end

    create_table :communication_media_localizations, id: :uuid do |t|
      t.string :name
      t.text :alt
      t.text :credit
      t.references :language, null: false, foreign_key: true, type: :uuid
      t.references :about, null: false, foreign_key: {to_table: :communication_medias}, type: :uuid
      t.references :university, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
