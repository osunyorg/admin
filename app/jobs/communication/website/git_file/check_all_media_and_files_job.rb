# Lance la vérification des git_files des médias et des fichiers,
# site par site, pour ne charger l'arbre de chaque dépôt qu'une seule fois.
class Communication::Website::GitFile::CheckAllMediaAndFilesJob < ApplicationJob
  self.good_job_labels = ['website']

  queue_as :elephants

  def perform
    Git::MediaAndFilesChecker.websites.find_each do |website|
      Communication::Website::GitFile::CheckMediaAndFilesJob.perform_later(website.id)
    end
  end
end
