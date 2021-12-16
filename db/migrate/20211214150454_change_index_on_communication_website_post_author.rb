class ChangeIndexOnCommunicationWebsitePostAuthor < ActiveRecord::Migration[6.1]
  def change
    remove_foreign_key :communication_website_posts, column: :author_id
    add_foreign_key :communication_website_posts, :administration_members, column: :author_id
  end
end
