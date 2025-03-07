class CreateCommunicationWebsiteAgendaMonths < ActiveRecord::Migration[7.2]
  def change
    create_table :communication_website_agenda_months, id: :uuid do |t|
      t.references :university, null: false, foreign_key: true, type: :uuid
      t.references :communication_website, null: false, foreign_key: {to_table: :communication_websites}, type: :uuid
      t.references :year, null: false, foreign_key: {to_table: :communication_website_agenda_years}, type: :uuid
      t.integer :value

      t.timestamps
    end
  end
end
