class AddAuthorToCommunicationWebsitePost < ActiveRecord::Migration[6.1]
  def change
    add_reference :communication_website_posts, :author, foreign_key: { to_table: :communication_website_authors }, type: :uuid
    
  end
end
