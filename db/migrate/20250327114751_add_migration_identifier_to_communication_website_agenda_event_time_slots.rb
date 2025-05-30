class AddMigrationIdentifierToCommunicationWebsiteAgendaEventTimeSlots < ActiveRecord::Migration[8.0]
  def change
    add_column :communication_website_agenda_event_time_slots, :migration_identifier, :string
    add_column :communication_website_agenda_event_time_slot_localizations, :migration_identifier, :string
  end
end
