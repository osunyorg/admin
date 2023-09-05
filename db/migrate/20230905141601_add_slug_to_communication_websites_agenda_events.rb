class AddSlugToCommunicationWebsitesAgendaEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :communication_website_agenda_events, :slug, :text
  end
end
