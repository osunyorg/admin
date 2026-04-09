class RemoveParanoidFromAgendaPeriodLocalizations < ActiveRecord::Migration[8.0]
  def change
    remove_column :communication_website_agenda_period_year_localizations, :deleted_at
    remove_column :communication_website_agenda_period_month_localizations, :deleted_at
    remove_column :communication_website_agenda_period_day_localizations, :deleted_at
  end
end
