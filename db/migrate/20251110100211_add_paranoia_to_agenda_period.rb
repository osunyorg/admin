class AddParanoiaToAgendaPeriod < ActiveRecord::Migration[8.0]
  def change
    add_column :communication_website_agenda_period_years, :deleted_at, :datetime
    add_column :communication_website_agenda_period_months, :deleted_at, :datetime
    add_column :communication_website_agenda_period_days, :deleted_at, :datetime
    add_column :communication_website_agenda_period_year_localizations, :deleted_at, :datetime
    add_column :communication_website_agenda_period_month_localizations, :deleted_at, :datetime
    add_column :communication_website_agenda_period_day_localizations, :deleted_at, :datetime

  end
end
