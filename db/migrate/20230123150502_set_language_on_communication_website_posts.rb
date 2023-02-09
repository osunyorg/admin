class SetLanguageOnCommunicationWebsitePosts < ActiveRecord::Migration[7.0]
  def change
    add_reference :communication_website_posts, :original, foreign_key: {to_table: :communication_website_posts}, type: :uuid

    Communication::Website.find_each do |website|
      website.posts.where(language_id: nil).update_all(language_id: website.default_language_id)
    end

    change_column_null :communication_website_posts, :language_id, false
  end
end
