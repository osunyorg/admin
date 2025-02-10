class AddHeaderCtaEverywhere < ActiveRecord::Migration[7.2]
  def change
    add_column :communication_website_post_localizations, :header_cta, :boolean, default: false
    add_column :communication_website_post_localizations, :header_cta_label, :string
    add_column :communication_website_post_localizations, :header_cta_url, :string
    add_column :communication_website_agenda_event_localizations, :header_cta, :boolean, default: false
    add_column :communication_website_agenda_event_localizations, :header_cta_label, :string
    add_column :communication_website_agenda_event_localizations, :header_cta_url, :string
  end
end
