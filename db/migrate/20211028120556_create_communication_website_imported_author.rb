class CreateCommunicationWebsiteImportedAuthor < ActiveRecord::Migration[6.1]
  def change
    create_table :communication_website_imported_authors, id: :uuid do |t|
      t.references :university,
                   null: false,
                   foreign_key: true,
                   type: :uuid,
                   index: { name: 'idx_communication_website_imported_auth_on_university' }
      t.references :website,
                   null: false,
                   foreign_key: { to_table: :communication_website_imported_websites },
                   type: :uuid,
                   index: { name: 'idx_communication_website_imported_auth_on_website' }
      t.references :author,
                   null: false,
                   foreign_key: { to_table: :communication_website_authors },
                   type: :uuid,
                   index: { name: 'idx_communication_website_imported_auth_on_author' }

      t.string :name
      t.text :description
      t.string :slug
      t.string :identifier
      t.jsonb :data
      t.timestamps
    end
  end
end
