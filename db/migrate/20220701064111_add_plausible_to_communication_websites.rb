class AddPlausibleToCommunicationWebsites < ActiveRecord::Migration[6.1]
  def change
    add_column :communication_websites, :plausible_url, :string
  end
end
