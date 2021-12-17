module Communication::Website::WithMedia
  extend ActiveSupport::Concern

  def active_storage_blobs
    blob_ids = [best_featured_image&.blob_id, text.embeds.blobs.pluck(:id)].flatten.compact
    university.active_storage_blobs.where(id: blob_ids)
  end

  # Can be overwrite to get featured_image from associated objects (ex: parents)
  def best_featured_image(fallback: true)
    featured_image
  end
end
