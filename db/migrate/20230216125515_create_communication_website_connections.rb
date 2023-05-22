class CreateCommunicationWebsiteConnections < ActiveRecord::Migration[7.0]
  def change
    create_table :communication_website_connections, id: :uuid do |t|
      t.references :university, null: false, foreign_key: true, type: :uuid
      t.references :website, null: false, foreign_key: {to_table: :communication_websites}, type: :uuid
      t.references :object, null: false, type: :uuid, polymorphic: true
      t.references :source, type: :uuid, polymorphic: true

      t.timestamps
    end
  end
end
