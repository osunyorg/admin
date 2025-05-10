class AddAddToCalendarUrlsToCommunicationWebsiteAgendaTimeSlotLocalizations < ActiveRecord::Migration[7.2]
  def change
    add_column :communication_website_agenda_event_time_slot_localizations, :add_to_calendar_urls, :jsonb
  end
end
