class AddNeedsCheckingToCommunicationWebsiteAgendaPeriodYears < ActiveRecord::Migration[8.0]
  def change
    add_column :communication_website_agenda_period_years, :needs_checking, :boolean, default: false
  end
end
