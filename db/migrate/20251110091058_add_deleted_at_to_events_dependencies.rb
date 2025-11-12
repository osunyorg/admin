class AddDeletedAtToEventsDependencies < ActiveRecord::Migration[8.0]
  def change
    add_column :communication_website_agenda_event_time_slots, :deleted_at, :datetime
    add_column :communication_website_agenda_event_days, :deleted_at, :datetime
    add_column :communication_website_agenda_event_time_slot_localizations, :deleted_at, :datetime
  end
end
