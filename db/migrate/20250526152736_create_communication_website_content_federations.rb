class CreateCommunicationWebsiteContentFederations < ActiveRecord::Migration[8.0]
  def change
    create_table :communication_website_content_federations, id: :uuid do |t|
      t.references :university, null: false, foreign_key: true, type: :uuid
      t.references :communication_website, null: false, foreign_key: true, type: :uuid
      t.references :about, polymorphic: true, null: false, type: :uuid
      t.references :destination_website, null: false, foreign_key: {to_table: :communication_websites}, type: :uuid

      t.timestamps
    end
  end
end
