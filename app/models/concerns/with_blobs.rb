module WithBlobs
  extend ActiveSupport::Concern

  def active_storage_blobs
    explicit_active_storage_blobs.or inherited_active_storage_blobs
  end

  def explicit_active_storage_blobs
    blobs_with_ids explicit_blob_ids
  end

  def inherited_active_storage_blobs
    blobs_with_ids inherited_blob_ids
  end

  protected

  def explicit_blob_ids
    []
  end

  def inherited_blob_ids
    []
  end

  def blobs_with_ids(ids)
    university.active_storage_blobs.where(id: ids.flatten.compact)
  end
end
