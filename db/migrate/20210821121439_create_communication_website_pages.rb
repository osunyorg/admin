class CreateCommunicationWebsitePages < ActiveRecord::Migration[6.1]
  def change
    create_table :communication_website_pages, id: :uuid do |t|
      t.references :university, null: false, foreign_key: true, type: :uuid
      t.references :communication_website, null: false, foreign_key: true, type: :uuid
      t.string :title
      t.text :description
      t.string :slug
      t.text :path
      t.datetime :published_at
      t.references :parent, foreign_key: {to_table: :communication_website_pages}, type: :uuid
      t.integer :position, default: 0, null: false
      t.references :about, polymorphic: true, type: :uuid

      t.timestamps
    end
  end
end
