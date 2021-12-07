module Communication::Website::WithMedia
  extend ActiveSupport::Concern

  def active_storage_blobs
    blob_ids = [featured_image&.blob_id, text.embeds.blobs.pluck(:id)].flatten.compact
    university.active_storage_blobs.where(id: blob_ids)
  end
end
