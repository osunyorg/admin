class AddLockedAtToCommunicationWebsites < ActiveRecord::Migration[7.1]
  def change
    add_column :communication_websites, :locked_at, :datetime
  end
end
