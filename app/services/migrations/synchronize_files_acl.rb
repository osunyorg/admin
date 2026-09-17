# Resynchronise l'ACL de tous les fichiers existants avec leur état de publication.
# Les fichiers non publiés, historiquement envoyés en public, repassent en privé.
class Migrations::SynchronizeFilesAcl
  def self.migrate
    Communication::File::Localization.find_each do |localization|
      Communication::File::SynchronizeBlobAclJob.perform_later(localization)
    end
  end
end
