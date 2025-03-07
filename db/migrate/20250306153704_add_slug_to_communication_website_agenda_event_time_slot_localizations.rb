class AddSlugToCommunicationWebsiteAgendaEventTimeSlotLocalizations < ActiveRecord::Migration[7.2]
  def change
    add_column :communication_website_agenda_event_time_slot_localizations, :slug, :string
  end
end
