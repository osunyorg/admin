class CreateCommunicationFiles < ActiveRecord::Migration[8.1]
  def change
    create_table :communication_files, id: :uuid do |t|
      t.references :university, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end

    create_table :communication_file_localizations, id: :uuid do |t|
      t.string :name
      t.string :slug
      t.text :internal_description
      t.bigint :original_byte_size
      t.string :original_checksum
      t.string :original_content_type
      t.string :original_filename
      t.references :original_blob, null: false, foreign_key: {to_table: :active_storage_blobs}, type: :uuid
      t.references :language, null: false, foreign_key: true, type: :uuid
      t.references :about, null: false, foreign_key: {to_table: :communication_files}, type: :uuid
      t.references :university, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
