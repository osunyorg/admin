class CreateCommunicationWebsitePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :communication_website_posts, id: :uuid do |t|
      t.references :university, null: false, foreign_key: true, type: :uuid
      t.references :communication_website, null: false, foreign_key: true, type: :uuid
      t.string :title
      t.text :description
      t.text :text
      t.boolean :published, default: false
      t.datetime :published_at

      t.timestamps
    end
  end
end
