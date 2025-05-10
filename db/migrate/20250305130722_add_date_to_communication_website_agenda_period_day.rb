class AddDateToCommunicationWebsiteAgendaPeriodDay < ActiveRecord::Migration[7.2]
  def change
    add_column :communication_website_agenda_period_days, :date, :date
  end
end
