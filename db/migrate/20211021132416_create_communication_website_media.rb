class CreateCommunicationWebsiteMedia < ActiveRecord::Migration[6.1]
  def change
    create_table :communication_website_media, id: :uuid do |t|
      t.string :identifier
      t.string :filename
      t.string :mime_type
      t.text :file_url
      t.references :university, null: false, foreign_key: true, type: :uuid
      t.references :website, null: false, foreign_key: { to_table: :communication_websites }, type: :uuid

      t.timestamps
    end
  end
end
