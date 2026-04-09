class AddDeletedAtToAgenda < ActiveRecord::Migration[8.0]
  def change
    add_column :communication_website_agenda_events, :deleted_at, :datetime
    add_column :communication_website_agenda_event_localizations, :deleted_at, :datetime
    add_column :communication_website_agenda_exhibitions, :deleted_at, :datetime
    add_column :communication_website_agenda_exhibition_localizations, :deleted_at, :datetime
  end
end
