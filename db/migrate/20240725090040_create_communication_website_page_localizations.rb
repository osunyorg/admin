class CreateCommunicationWebsitePageLocalizations < ActiveRecord::Migration[7.1]
  def up
    # Warning
    # - Gérer correctement les special pages

    change_column_null :communication_website_pages, :language_id, true

    create_table :communication_website_page_localizations, id: :uuid do |t|
      t.string :breadcrumb_title
      t.string :featured_image_alt
      t.text :featured_image_credit
      t.boolean :header_cta
      t.string :header_cta_label
      t.string :header_cta_url
      t.text :header_text
      t.string :meta_description
      t.string :migration_identifier
      t.boolean :published
      t.datetime :published_at
      t.string :slug
      t.text :summary
      t.text :text
      t.string :title

      t.references :about, foreign_key: { to_table: :communication_website_pages }, type: :uuid
      t.references :language, foreign_key: true, type: :uuid
      t.references :communication_website, foreign_key: true, type: :uuid
      t.references :university, foreign_key: true, type: :uuid

      t.timestamps
    end
  end

  def down
    drop_table :communication_website_page_localizations
  end
end
