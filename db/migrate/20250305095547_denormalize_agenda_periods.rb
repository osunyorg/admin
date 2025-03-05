class DenormalizeAgendaPeriods < ActiveRecord::Migration[7.2]
  def change
    add_column :communication_website_agenda_period_year_localizations, :events_count, :integer, default: 0
    add_column :communication_website_agenda_period_month_localizations, :events_count, :integer, default: 0
  end
end
