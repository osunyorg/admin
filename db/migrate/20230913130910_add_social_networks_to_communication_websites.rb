class AddSocialNetworksToCommunicationWebsites < ActiveRecord::Migration[7.0]
  def change
    add_column :communication_websites, :social_mastodon, :string
    add_column :communication_websites, :social_x, :string
    add_column :communication_websites, :social_linkedin, :string
    add_column :communication_websites, :social_youtube, :string
    add_column :communication_websites, :social_vimeo, :string
    add_column :communication_websites, :social_peertube, :string
    add_column :communication_websites, :social_instagram, :string
    add_column :communication_websites, :social_facebook, :string
  end
end
