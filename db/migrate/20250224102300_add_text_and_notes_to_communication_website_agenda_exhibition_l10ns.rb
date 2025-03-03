class AddTextAndNotesToCommunicationWebsiteAgendaExhibitionL10ns < ActiveRecord::Migration[7.2]
  def change
    add_column :communication_website_agenda_exhibition_localizations, :text, :text
    add_column :communication_website_agenda_exhibition_localizations, :notes, :text
  end
end
