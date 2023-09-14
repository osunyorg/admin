class AddTiktokToCommunicationWebsites < ActiveRecord::Migration[7.0]
  def change
    add_column :communication_websites, :social_tiktok, :string
  end
end
