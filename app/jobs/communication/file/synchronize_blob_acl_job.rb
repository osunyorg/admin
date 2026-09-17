# Synchronise l'ACL du blob d'une localisation de fichier sur le service de
# stockage, en fonction de son état de publication courant.
class Communication::File::SynchronizeBlobAclJob < ApplicationJob
  queue_as :mice

  def perform(localization)
    localization.synchronize_blob_acl_safely
  end
end
