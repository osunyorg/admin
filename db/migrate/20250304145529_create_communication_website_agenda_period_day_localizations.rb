class CreateCommunicationWebsiteAgendaPeriodDayLocalizations < ActiveRecord::Migration[7.2]
  def change
    create_table :communication_website_agenda_period_day_localizations, id: :uuid do |t|
      t.string :slug
      t.integer :events_count, default: 0

      t.references :university, null: false, foreign_key: true, type: :uuid
      t.references :communication_website, null: false, foreign_key: true, type: :uuid
      t.references :language, null: false, foreign_key: true, type: :uuid
      t.references :about, null: false, foreign_key: { to_table: :communication_website_agenda_period_days }, type: :uuid

      t.timestamps
    end
  end
end
