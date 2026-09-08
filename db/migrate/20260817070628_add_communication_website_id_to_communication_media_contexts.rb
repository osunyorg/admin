class AddCommunicationWebsiteIdToCommunicationMediaContexts < ActiveRecord::Migration[8.1]
  def change
    add_reference :communication_media_contexts, :communication_website, null: true, foreign_key: true, type: :uuid
  end
end
