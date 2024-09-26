class RemoveCommunicationWebsiteAgendaEventOldI18n < ActiveRecord::Migration[7.1]
  def change
    remove_colum :communication_website_agenda_events, :original_id
    remove_colum :communication_website_agenda_events, :language_id
    remove_colum :communication_website_agenda_events, :add_to_calendar_urls
    remove_colum :communication_website_agenda_events, :featured_image_alt
    remove_colum :communication_website_agenda_events, :featured_image_credit
    remove_colum :communication_website_agenda_events, :meta_description
    remove_colum :communication_website_agenda_events, :published
    remove_colum :communication_website_agenda_events, :published_at
    remove_colum :communication_website_agenda_events, :slug
    remove_colum :communication_website_agenda_events, :subtitle
    remove_colum :communication_website_agenda_events, :summary
    remove_colum :communication_website_agenda_events, :title

  end
end
