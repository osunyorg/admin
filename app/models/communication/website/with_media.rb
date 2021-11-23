module Communication::Website::WithMedia
  extend ActiveSupport::Concern

  included do
    after_save_commit :publish_media_to_github
  end

  def active_storage_blobs
    blob_ids = [featured_image&.blob_id, text.embeds.blobs.pluck(:id)].flatten.compact
    university.active_storage_blobs.where(id: blob_ids)
  end

  protected

  def publish_media_to_github
    active_storage_blobs.each { |blob| website.publish_blob(blob) }
  end
end
