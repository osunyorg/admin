class CreateCommunicationWebsiteImportedPosts < ActiveRecord::Migration[6.1]
  def change
    create_table :communication_website_imported_posts, id: :uuid do |t|
      t.references :university, null: false, foreign_key: true, type: :uuid
      t.references :website, null: false, foreign_key: {to_table: :communication_website_imported_websites}, type: :uuid
      t.references :post, null: false, foreign_key: {to_table: :communication_website_posts}, type: :uuid
      t.integer :status, default: 0
      t.string :title
      t.text :description
      t.text :content
      t.text :path
      t.text :url
      t.datetime :published_at
      t.string :identifier

      t.timestamps
    end
  end
end
