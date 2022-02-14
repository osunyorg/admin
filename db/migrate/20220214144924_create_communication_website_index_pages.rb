class CreateCommunicationWebsiteIndexPages < ActiveRecord::Migration[6.1]
  def change
    create_table :communication_website_index_pages, id: :uuid do |t|
      t.references :university, null: false, foreign_key: true, type: :uuid
      t.references :communication_website,
          null: false,
          foreign_key: { to_table: :communication_websites },
          type: :uuid,
          index: { name: 'idx_comm_website_index_page_on_communication_website_id' }

      t.string :title
      t.string :path
      t.text :description
      t.text :text
      t.string :featured_image_alt
      t.integer :kind

      t.timestamps
    end
  end
end
