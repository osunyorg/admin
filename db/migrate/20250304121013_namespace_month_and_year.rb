class NamespaceMonthAndYear < ActiveRecord::Migration[7.2]
  def change
    rename_table :communication_website_agenda_years, :communication_website_agenda_period_years
    rename_table :communication_website_agenda_months, :communication_website_agenda_period_months
    rename_table :communication_website_agenda_year_localizations, :communication_website_agenda_period_year_localizations
    rename_table :communication_website_agenda_month_localizations, :communication_website_agenda_period_month_localizations
  end
end
