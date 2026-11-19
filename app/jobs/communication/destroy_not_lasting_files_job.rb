class Communication::DestroyNotLastingFilesJob < ApplicationJob
  queue_as :elephants


  def perform
    # On supprime les fichiers non pérennes créés il y a + de 30 jours n'ayant plus de contexte (via leurs localisations)
    Communication::File.deletable.destroy_all
  end
end
