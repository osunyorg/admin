class AddNewTextToWebsiteCommunicationPost < ActiveRecord::Migration[6.1]
  def change
    add_column :communication_website_posts, :text_new, :text
  end
end
