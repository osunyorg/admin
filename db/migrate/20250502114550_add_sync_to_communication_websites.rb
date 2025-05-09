class AddSyncToCommunicationWebsites < ActiveRecord::Migration[8.0]
  def change
    add_column :communication_websites, :last_sync_at, :datetime
  end
end
