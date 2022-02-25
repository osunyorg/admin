class ChangeStringToTextInCommunicationWebsiteIndexPages < ActiveRecord::Migration[6.1]
  def change
    change_column :communication_website_index_pages, :header_text, :text
  end
end
