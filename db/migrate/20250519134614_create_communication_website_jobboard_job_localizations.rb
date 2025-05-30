class CreateCommunicationWebsiteJobboardJobLocalizations < ActiveRecord::Migration[8.0]
  def change
    create_table :communication_website_jobboard_job_localizations, id: :uuid do |t|
      t.string :featured_image_alt
      t.text :featured_image_credit
      t.string :meta_description
      t.string :migration_identifier
      t.boolean :published, default: false
      t.datetime :published_at
      t.string :slug
      t.string :subtitle
      t.text :description
      t.string :title
      t.boolean :header_cta, default: false
      t.string :header_cta_label
      t.string :header_cta_url
      t.references :about, foreign_key: { to_table: :communication_website_jobboard_jobs }, type: :uuid
      t.references :language, foreign_key: true, type: :uuid
      t.references :communication_website, foreign_key: true, type: :uuid
      t.references :university, foreign_key: true, type: :uuid
      t.timestamps
    end
  end
end