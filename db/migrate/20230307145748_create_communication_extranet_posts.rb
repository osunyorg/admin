class CreateCommunicationExtranetPosts < ActiveRecord::Migration[7.0]
  def change
    create_table :communication_extranet_posts, id: :uuid do |t|
      t.string :title
      t.boolean :published, default: false
      t.datetime :published_at
      t.references :author, foreign_key: {to_table: :university_people}, type: :uuid
      t.references :extranet, null: false, foreign_key: {to_table: :communication_extranets}, type: :uuid
      t.references :university, null: false, foreign_key: true, type: :uuid
      t.string :featured_image_alt
      t.text :featured_image_credit
      t.string :slug
      t.text :summary

      t.timestamps
    end
  end
end
