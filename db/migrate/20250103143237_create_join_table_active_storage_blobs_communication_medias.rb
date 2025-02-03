class CreateJoinTableActiveStorageBlobsCommunicationMedias < ActiveRecord::Migration[7.2]
  def change
    create_table :communication_media_contexts, id: :uuid  do |t|
      t.references :communication_media, null: false, foreign_key: true, type: :uuid
      t.references :active_storage_blob, null: false, foreign_key: true, type: :uuid
      t.references :about, polymorphic: true, type: :uuid
      t.references :university, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
