class AddWebsiteToCommunicationFileContexts < ActiveRecord::Migration[8.1]
  def change
    add_reference :communication_file_contexts, :communication_website, null: true, foreign_key: true, type: :uuid
  end
end
