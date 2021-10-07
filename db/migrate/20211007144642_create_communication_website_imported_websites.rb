class CreateCommunicationWebsiteImportedWebsites < ActiveRecord::Migration[6.1]
  def change
    create_table :communication_website_imported_websites, id: :uuid do |t|
      t.references :university, null: false, foreign_key: true, type: :uuid
      t.references :website, null: false, foreign_key: {to_table: :communication_websites}, type: :uuid
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
