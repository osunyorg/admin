class AddShowcaseHighlightCommunicationWebsites < ActiveRecord::Migration[7.1]
  def change
    add_column :communication_websites, :showcase_highlight, :boolean, default: false
  end
end
