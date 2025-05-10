class CreateCommunicationWebsiteAgendaPeriodDays < ActiveRecord::Migration[7.2]
  def change
    create_table :communication_website_agenda_period_days, id: :uuid do |t|
      t.integer :value

      t.references :university, null: false, foreign_key: true, type: :uuid
      t.references :communication_website, null: false, foreign_key: true, type: :uuid
      t.references :year, null: false, foreign_key: { to_table: :communication_website_agenda_period_years }, type: :uuid
      t.references :month, null: false, foreign_key: { to_table: :communication_website_agenda_period_months }, type: :uuid

      t.timestamps
    end
  end
end
