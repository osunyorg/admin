class AddUniversityIdToActiveStorageBlob < ActiveRecord::Migration[6.1]
  def change
    add_reference :active_storage_blobs, :university, type: :uuid, index: true

  end
end
