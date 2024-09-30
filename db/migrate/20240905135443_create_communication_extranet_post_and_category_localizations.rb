class CreateCommunicationExtranetPostAndCategoryLocalizations < ActiveRecord::Migration[7.1]
  def up
    create_table :communication_extranet_post_localizations, id: :uuid do |t|
      t.string :featured_image_alt
      t.text :featured_image_credit
      t.boolean :published, default: false
      t.boolean :pinned, default: false
      t.datetime :published_at
      t.string :slug
      t.text :summary
      t.string :title

      t.references :about, foreign_key: { to_table: :communication_extranet_posts }, type: :uuid
      t.references :language, foreign_key: true, type: :uuid
      t.references :extranet, foreign_key: { to_table: :communication_extranets }, type: :uuid
      t.references :university, foreign_key: true, type: :uuid

      t.timestamps
    end
    create_table :communication_extranet_post_category_localizations, id: :uuid do |t|
      t.string :slug
      t.string :name

      t.references :about, foreign_key: { to_table: :communication_extranet_post_categories }, type: :uuid
      t.references :language, foreign_key: true, type: :uuid
      t.references :extranet, foreign_key: { to_table: :communication_extranets }, type: :uuid
      t.references :university, foreign_key: true, type: :uuid

      t.timestamps
    end
  end

  def down
    drop_table :communication_extranet_post_localizations
    drop_table :communication_extranet_post_category_localizations
  end
end
