class CreateCommunicationAgendaEventLocalizations < ActiveRecord::Migration[7.1]
  def up
    change_column_null :communication_website_agenda_events, :language_id, true

    create_table :communication_website_agenda_event_localizations, id: :uuid do |t|
      t.jsonb :add_to_calendar_urls
      t.string :featured_image_alt
      t.text :featured_image_credit
      t.string :meta_description
      t.string :migration_identifier
      t.boolean :published, default: false
      t.datetime :published_at
      t.string :slug
      t.string :subtitle
      t.text :summary
      t.text :text # No text yet
      t.string :title

      t.references :about, foreign_key: { to_table: :communication_website_agenda_events }, type: :uuid
      t.references :language, foreign_key: true, type: :uuid
      t.references :communication_website, foreign_key: true, type: :uuid
      t.references :university, foreign_key: true, type: :uuid

      t.timestamps
    end
  end

  def down
    drop_table :communication_website_agenda_event_localizations
  end
end
