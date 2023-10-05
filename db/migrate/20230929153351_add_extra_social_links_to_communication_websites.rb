class AddExtraSocialLinksToCommunicationWebsites < ActiveRecord::Migration[7.0]
  def change
    add_column :communication_websites, :social_email, :string
    add_column :communication_websites, :social_github, :string
  end
end
