# Gère l'ACL du fichier stocké (blob) en fonction de l'état de publication :
# - une localisation publiée      => fichier public  (public-read)
# - une localisation non publiée  => fichier privé   (private)
#
# Le service de stockage (Scaleway/S3) est configuré en `public: true`, donc tous
# les uploads (y compris les uploads directs navigateur -> S3) partent en public-read.
# On resynchronise donc l'ACL de l'objet après coup, à chaque changement d'état de
# publication ou de blob, via une tâche de fond (appel réseau au service de stockage).
module Communication::File::Localization::WithAcl
  extend ActiveSupport::Concern

  ACL_PUBLIC = 'public-read'
  ACL_PRIVATE = 'private'

  included do
    after_save_commit :synchronize_blob_acl, if: :should_synchronize_blob_acl?
    after_restore :synchronize_blob_acl
  end

  # ACL cible en fonction de l'état de publication
  def blob_acl
    published? ? ACL_PUBLIC : ACL_PRIVATE
  end

  # Appelé par Communication::File::SynchronizeBlobAclJob
  def synchronize_blob_acl_safely
    apply_acl_to original_blob
  end

  protected

  def synchronize_blob_acl
    Communication::File::SynchronizeBlobAclJob.perform_later(self)
  end

  def should_synchronize_blob_acl?
    return false if original_blob_id.blank?
    saved_change_to_original_blob_id? ||
    saved_change_to_published? ||
    saved_change_to_published_at?
  end

  def apply_acl_to(blob)
    return if blob.blank?
    service = blob.service
    # Les services locaux (disque, tests) ne gèrent pas d'ACL
    return unless service.respond_to?(:bucket)
    service.bucket.object(blob.key).acl.put(acl: blob_acl)
  end
end
