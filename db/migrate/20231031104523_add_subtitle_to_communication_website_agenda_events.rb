class AddSubtitleToCommunicationWebsiteAgendaEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :communication_website_agenda_events, :subtitle, :string
  end
end
