class AddPlaceToCommunicationWebsiteAgendaExhibitionL10ns < ActiveRecord::Migration[7.2]
  def change
    add_column :communication_website_agenda_exhibition_localizations, :place, :string
  end
end
