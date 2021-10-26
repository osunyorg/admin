class CreateCommunicationWebsiteCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :communication_website_categories, id: :uuid do |t|
      t.references :university, null: false, foreign_key: true, type: :uuid
      t.references :communication_website,
                    null: false,
                    foreign_key: { to_table: :communication_websites },
                    type: :uuid,
                    index: { name: 'idx_communication_website_post_cats_on_communication_website_id' }
      t.string :name
      t.text :description
      t.integer :position
      t.timestamps
    end
  end
end
