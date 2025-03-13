class CreateCommunicationWebsiteAgendaYearLocalizations < ActiveRecord::Migration[7.2]
  def change
    create_table :communication_website_agenda_year_localizations, id: :uuid do |t|
      t.string :slug

      t.references :about, foreign_key: { to_table: :communication_website_agenda_years }, type: :uuid
      t.references :language, foreign_key: true, type: :uuid
      t.references :communication_website, type: :uuid
      t.references :university, foreign_key: true, type: :uuid

      t.timestamps
    end

    create_table :communication_website_agenda_month_localizations, id: :uuid do |t|
      t.string :slug

      t.references :about, foreign_key: { to_table: :communication_website_agenda_months }, type: :uuid
      t.references :language, foreign_key: true, type: :uuid
      t.references :communication_website, type: :uuid
      t.references :university, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
