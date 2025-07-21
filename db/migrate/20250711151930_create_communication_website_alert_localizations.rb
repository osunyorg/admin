class CreateCommunicationWebsiteAlertLocalizations < ActiveRecord::Migration[8.0]
  def change
    create_table :communication_website_alert_localizations, id: :uuid do |t|
      t.string :title
      t.string :slug
      t.text :description
      t.boolean :cta, default: false
      t.string :cta_label
      t.string :cta_url
      t.boolean :published, default: false
      t.datetime :published_at
      t.references :about, null: false, foreign_key: { to_table: :communication_website_alerts }, type: :uuid
      t.references :language, null: false, foreign_key: true, type: :uuid
      t.references :communication_website, null: false, foreign_key: true, type: :uuid
      t.references :university, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
