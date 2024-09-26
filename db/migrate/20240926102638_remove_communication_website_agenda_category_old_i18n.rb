class RemoveCommunicationWebsiteAgendaCategoryOldI18n < ActiveRecord::Migration[7.1]
  def change
    remove_column :communication_website_agenda_categories, :original_id
    remove_column :communication_website_agenda_categories, :language_id
    remove_column :communication_website_agenda_categories, :featured_image_alt
    remove_column :communication_website_agenda_categories, :featured_image_credit
    remove_column :communication_website_agenda_categories, :meta_description
    remove_column :communication_website_agenda_categories, :name
    remove_column :communication_website_agenda_categories, :path
    remove_column :communication_website_agenda_categories, :slug
    remove_column :communication_website_agenda_categories, :summary

  end
end
