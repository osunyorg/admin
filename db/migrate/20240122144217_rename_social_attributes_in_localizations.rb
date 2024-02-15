class RenameSocialAttributesInLocalizations < ActiveRecord::Migration[7.1]
  def change
    rename_column :communication_website_localizations, :email,      :social_email
    rename_column :communication_website_localizations, :mastodon,   :social_mastodon
    rename_column :communication_website_localizations, :peertube,   :social_peertube
    rename_column :communication_website_localizations, :x,          :social_x
    rename_column :communication_website_localizations, :github,     :social_github
    rename_column :communication_website_localizations, :linkedin,   :social_linkedin
    rename_column :communication_website_localizations, :youtube,    :social_youtube
    rename_column :communication_website_localizations, :vimeo,      :social_vimeo
    rename_column :communication_website_localizations, :instagram,  :social_instagram
    rename_column :communication_website_localizations, :facebook,   :social_facebook
    rename_column :communication_website_localizations, :tiktok,     :social_tiktok
  end
end
