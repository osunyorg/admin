class MoveJoinTableCommunicationWebsiteAgendaCategories < ActiveRecord::Migration[7.1]
  def change
    rename_column :communication_website_agenda_events_categories, :communication_website_category_id, :communication_website_agenda_category_id
  end
end
