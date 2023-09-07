class CreateCommunicationWebsiteAgendaEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :communication_website_agenda_events, id: :uuid do |t|
      t.string :title
      t.text :summary
      t.references :university, null: false, foreign_key: true, type: :uuid
      t.references :communication_website, null: false, foreign_key: true, type: :uuid, index: { name: 'index_agenda_events_on_communication_website_id' }
      t.references :language, null: false, foreign_key: true, type: :uuid
      t.references :original, null: false, foreign_key: {to_table: :communication_website_agenda_events}, type: :uuid
      t.boolean :published, default: false
      t.date :from_day
      t.time :from_hour
      t.date :to_day
      t.time :to_hour
      t.text :featured_image_alt
      t.text :featured_image_credit
      t.text :meta_description
      t.references :parent, null: false, foreign_key: {to_table: :communication_website_agenda_events}, type: :uuid

      t.timestamps
    end
  end
end
