class AddTemplateToCommunicationWebsiteAgendaEvent < ActiveRecord::Migration[8.0]
  def change
    add_column :communication_website_agenda_events, :is_template, :boolean, default: false
    add_reference :communication_website_agenda_events, :template, type: :uuid, null: true, foreign_key: { to_table: :communication_website_agenda_events }
  end
end
