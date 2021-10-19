class CreateCommunicationWebsiteImportedMedia < ActiveRecord::Migration[6.1]
  def change
    create_table :communication_website_imported_media, id: :uuid do |t|
      t.string :identifier
      t.jsonb :data
      t.text :file_url
      t.datetime :remote_created_at
      t.datetime :remote_updated_at
      t.references :university, null: false, foreign_key: true, type: :uuid
      t.references :website, null: false, foreign_key: { to_table: :communication_website_imported_websites }, type: :uuid

      t.timestamps
    end
  end
end
