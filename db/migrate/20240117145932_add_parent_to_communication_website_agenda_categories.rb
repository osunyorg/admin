class AddParentToCommunicationWebsiteAgendaCategories < ActiveRecord::Migration[7.1]
  def change
    add_reference :communication_website_agenda_categories, :parent, foreign_key: {to_table: :communication_website_agenda_categories}, type: :uuid
  end
end
