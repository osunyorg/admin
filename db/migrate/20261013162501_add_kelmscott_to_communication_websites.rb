class AddKelmscottToCommunicationWebsites < ActiveRecord::Migration[8.1]
  def change
    add_column :communication_websites, :kelmscott_active, :boolean, default: false
    add_column :communication_websites, :kelmscott_sync_method, :integer
  end
end
