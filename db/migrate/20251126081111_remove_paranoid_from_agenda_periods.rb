class RemoveParanoidFromAgendaPeriods < ActiveRecord::Migration[8.0]
  def change
    remove_column :communication_website_agenda_event_days, :deleted_at
    remove_column :communication_website_agenda_period_years, :deleted_at
    remove_column :communication_website_agenda_period_months, :deleted_at
    remove_column :communication_website_agenda_period_days, :deleted_at
  end
end
