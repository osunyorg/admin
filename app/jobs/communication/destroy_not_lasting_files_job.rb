class Communication::DestroyNotLastingFilesJob < ApplicationJob
  queue_as :elephants

  DELAY_AFTER_CREATION_BEFORE_DESTROY = 30.days

  def perform
    # On supprime les fichiers non pérennes créés il y a + de 30 jours n'ayant plus de contexte (via leurs localisations)
    Communication::File.where("communication_files.created_at < ?", DELAY_AFTER_CREATION_BEFORE_DESTROY.ago)
                       .for_lasting(false)
                       .where.missing(:contexts)
                       .destroy_all
  end
end
