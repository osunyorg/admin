class CreateJoinTableActiveStorageBlobsCommunicationMedias < ActiveRecord::Migration[7.2]
  def change
    create_join_table :active_storage_blobs, :communication_medias, column_options: {type: :uuid}  do |t|
      t.index [:active_storage_blob_id, :communication_media_id], name: 'blob_media'
      t.index [:communication_media_id, :active_storage_blob_id], name: 'media_blob'
    end
  end
end
