class RemoveCommunicationWebsiteOldI18n < ActiveRecord::Migration[7.1]
  def change
    remove_colum :communication_websites, :name
    remove_colum :communication_websites, :social_email
    remove_colum :communication_websites, :social_mastodon
    remove_colum :communication_websites, :social_peertube
    remove_colum :communication_websites, :social_x
    remove_colum :communication_websites, :social_github
    remove_colum :communication_websites, :social_linkedin
    remove_colum :communication_websites, :social_youtube
    remove_colum :communication_websites, :social_vimeo
    remove_colum :communication_websites, :social_instagram
    remove_colum :communication_websites, :social_facebook
    remove_colum :communication_websites, :social_tiktok
    remove_colum :communication_websites, :published
    remove_colum :communication_websites, :published_at

  end
end
