class AddI18nInfosToCommunicationPages < ActiveRecord::Migration[7.0]
  # communication_website_pages already have language_id
  def up
    add_reference :communication_website_pages, :original, foreign_key: {to_table: :communication_website_pages}, type: :uuid
    Communication::Website::Page.where(language_id: nil).each do |page|
      page.update_column(:language_id, page.website.default_language_id)
    end
  end

  def down
    remove_reference :communication_website_pages, :original
  end
end
