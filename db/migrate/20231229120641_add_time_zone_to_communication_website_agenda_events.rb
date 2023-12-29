class AddTimeZoneToCommunicationWebsiteAgendaEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :communication_website_agenda_events, :time_zone, :string
    Communication::Website::Agenda::Event.reset_column_information
    Communication::Website::Agenda::Event.update_all(time_zone: "Europe/Paris")
  end
end
