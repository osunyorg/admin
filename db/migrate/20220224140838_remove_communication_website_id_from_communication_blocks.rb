class RemoveCommunicationWebsiteIdFromCommunicationBlocks < ActiveRecord::Migration[6.1]
  def change
    remove_column :communication_blocks, :communication_website_id
  end
end
