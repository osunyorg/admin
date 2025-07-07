class RemoveFromAndToHoursToEvents < ActiveRecord::Migration[8.0]
  def change
    remove_column :communication_website_agenda_events, :from_hour
    remove_column :communication_website_agenda_events, :to_hour
  end
end
