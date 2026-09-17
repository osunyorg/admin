module Communication::File::Localization::WithStorageAcl
  extend ActiveSupport::Concern

  ACL_PUBLIC  = 'public-read'
  ACL_PRIVATE = 'private'

  included do
    after_commit :sync_blob_acl, if: :should_sync_blob_acl?
  end

  private

  def should_sync_blob_acl?
    return false unless original_blob_id.present?
    return false unless saved_change_to_original_blob_id? ||
                        saved_change_to_published? ||
                        saved_change_to_published_at?
    s3_service?
  end

  def sync_blob_acl
    return if original_blob.nil?
    s3_object.acl.put(acl: s3_acl)
  rescue StandardError => e
    Rails.logger.error("[Storage ACL] Localization #{id}: #{e.class} #{e.message}")
  end

  def s3_acl
    published? ? ACL_PUBLIC : ACL_PRIVATE
  end

  def s3_service?
    return false unless original_blob.present?
    original_blob.service.is_a?(ActiveStorage::Service::S3Service)
  end

  def s3_object
    original_blob.service.bucket.object(original_blob.key)
  end
end
