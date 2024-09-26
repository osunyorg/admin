class RemoveCommunicationWebsiteAgendaCategoryOldI18n < ActiveRecord::Migration[7.1]
  def change
    remove_colum :communication_website_agenda_categories, :original_id
    remove_colum :communication_website_agenda_categories, :language_id
    remove_colum :communication_website_agenda_categories, :featured_image_alt
    remove_colum :communication_website_agenda_categories, :featured_image_credit
    remove_colum :communication_website_agenda_categories, :meta_description
    remove_colum :communication_website_agenda_categories, :name
    remove_colum :communication_website_agenda_categories, :path
    remove_colum :communication_website_agenda_categories, :slug
    remove_colum :communication_website_agenda_categories, :summary

  end
end
