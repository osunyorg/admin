class AddLanguageToCommunicationPagesAndPosts < ActiveRecord::Migration[6.1]
  def change
    add_reference :communication_website_pages, :language, type: :uuid
    add_reference :communication_website_posts, :language, type: :uuid
  end
end
