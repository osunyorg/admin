class RemoveAgendaDenormForYearAndMonth < ActiveRecord::Migration[7.2]
  def change
    remove_column :communication_website_agenda_period_year_localizations, :events_count
    remove_column :communication_website_agenda_period_month_localizations, :events_count
  end
end
