class Migrations::CleanOrphanAttachments
  # Supprime les pièces jointes dont le record_type ne correspond plus à une classe existante (modèle retiré du code). 
  def self.migrate
    ActiveStorage::Attachment.with_deleted.find_each do |attachment|
      next if attachment.record_type.nil?
      next if attachment.record_type.safe_constantize
      attachment.delete
      puts "Orphan attachment #{attachment.id} (#{attachment.record_type}) deleted"
    end
  end
end
