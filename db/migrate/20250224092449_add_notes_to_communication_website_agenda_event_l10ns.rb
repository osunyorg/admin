class AddNotesToCommunicationWebsiteAgendaEventL10ns < ActiveRecord::Migration[7.2]
  def change
    add_column :communication_website_agenda_event_localizations, :notes, :text
  end
end
