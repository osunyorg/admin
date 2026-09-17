# Synchronise l'ACL du blob sur l'object storage (Scaleway) :
# le blob est privé tant qu'aucune localisation le référençant n'est
# publiée, et public dès qu'au moins une l'est.
#
# Plusieurs localisations (langues différentes) peuvent partager le
# même original_blob (voir AsLocalization#localize_in! qui duplique
# l'enregistrement). L'ACL ne passe donc à « private » que si aucune
# localisation référençant ce blob n'est publiée.
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
    s3_object.acl.put(acl: any_localization_published? ? ACL_PUBLIC : ACL_PRIVATE)
  rescue StandardError => e
    Rails.logger.error("[Storage ACL] Localization #{id}: #{e.class} #{e.message}")
  end

  # Une localisation est considérée publiée si published = true ET
  # published_at est dans le passé, conformément à Publishable#published_now?
  def any_localization_published?
    self.class
        .where(original_blob_id: original_blob_id)
        .where(published: true)
        .where('published_at IS NOT NULL AND published_at <= ?', Time.zone.now)
        .exists?
  end

  def s3_service?
    return false unless original_blob.present?
    original_blob.service.is_a?(ActiveStorage::Service::S3Service)
  end

  def s3_object
    original_blob.service.bucket.object(original_blob.key)
  end
end
