class CreateCommunicationWebsitePostLocalization < ActiveRecord::Migration[7.1]
  def up
    change_column_null :communication_website_posts, :language_id, true
    create_table :communication_website_post_localizations, id: :uuid do |t|
      t.string :featured_image_alt
      t.text :featured_image_credit
      t.text :meta_description
      t.string :migration_identifier
      t.boolean :pinned
      t.boolean :published
      t.datetime :published_at
      t.string  :slug
      t.text    :summary
      t.text :text
      t.string  :title

      t.references :about, foreign_key: { to_table: :communication_website_posts }, type: :uuid
      t.references :language, foreign_key: true, type: :uuid
      t.references :communication_website, foreign_key: true, type: :uuid
      t.references :university, foreign_key: true, type: :uuid

      t.timestamps
    end
  end

  def down
    drop_table :communication_website_post_localizations
  end
end
