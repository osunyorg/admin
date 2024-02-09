class AddAddToCalendarUrlsToCommunicationWebsiteAgendaEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :communication_website_agenda_events, :add_to_calendar_urls, :jsonb
    Communication::Website::Agenda::Event.reset_column_information
    Communication::Website::Agenda::Event.find_each(&:save)
  end
end
