class AddUniqueIndexToAgendaPeriods < ActiveRecord::Migration[7.2]
  def change
    add_index :communication_website_agenda_period_years,
              [:university_id, :communication_website_id, :value],
              unique: true,
              name: 'index_communication_website_agenda_period_years_unique'

    add_index :communication_website_agenda_period_months,
              [:university_id, :communication_website_id, :year_id, :value],
              unique: true,
              name: 'index_communication_website_agenda_period_months_unique'

    add_index :communication_website_agenda_period_days,
              [:university_id, :communication_website_id, :year_id, :month_id, :value],
              unique: true,
              name: 'index_communication_website_agenda_period_days_unique'
  end
end
