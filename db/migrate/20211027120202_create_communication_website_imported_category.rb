class CreateCommunicationWebsiteImportedCategory < ActiveRecord::Migration[6.1]
  def change
    create_table :communication_website_imported_categories, id: :uuid do |t|
      t.references :university,
                   null: false,
                   foreign_key: true,
                   type: :uuid,
                   index: { name: 'idx_communication_website_imported_cat_on_university' }
      t.references :website,
                   null: false,
                   foreign_key: { to_table: :communication_website_imported_websites },
                   type: :uuid,
                   index: { name: 'idx_communication_website_imported_cat_on_website' }
      t.references :category,
                   null: false,
                   foreign_key: { to_table: :communication_website_categories },
                   type: :uuid,
                   index: { name: 'idx_communication_website_imported_cat_on_category' }

      t.string :name
      t.text :description
      t.string :identifier
      t.string :slug
      t.string :url
      t.string :parent


      t.timestamps
    end
  end
end
