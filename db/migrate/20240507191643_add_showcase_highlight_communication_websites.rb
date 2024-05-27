class AddShowcaseHighlightCommunicationWebsites < ActiveRecord::Migration[7.1]
  def change
    add_column :communication_websites, :highlighted_in_showcase, :boolean, default: false
  end
end
