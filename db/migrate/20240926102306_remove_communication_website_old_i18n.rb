class RemoveCommunicationWebsiteOldI18n < ActiveRecord::Migration[7.1]
  def change
    remove_column :communication_websites, :name
    remove_column :communication_websites, :social_email
    remove_column :communication_websites, :social_mastodon
    remove_column :communication_websites, :social_peertube
    remove_column :communication_websites, :social_x
    remove_column :communication_websites, :social_github
    remove_column :communication_websites, :social_linkedin
    remove_column :communication_websites, :social_youtube
    remove_column :communication_websites, :social_vimeo
    remove_column :communication_websites, :social_instagram
    remove_column :communication_websites, :social_facebook
    remove_column :communication_websites, :social_tiktok
    remove_column :communication_websites, :published
    remove_column :communication_websites, :published_at

  end
end
