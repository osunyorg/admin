class AuthorizeNullOriginalForCommunicationWebsiteAgendaEvents < ActiveRecord::Migration[7.0]
  def change
    change_column_null :communication_website_agenda_events, :original_id, true
    change_column_null :communication_website_agenda_events, :parent_id, true
  end
end
