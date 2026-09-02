# Vérifie, pour un site, que les git_files des médias et des fichiers
# marqués comme à jour existent bien sur le dépôt Git.
class Communication::Website::GitFile::CheckMediaAndFilesJob < ApplicationJob
  self.good_job_labels = ['website']

  queue_as :elephants

  # Inutile de réessayer si le dépôt n'existe pas ou n'est plus accessible.
  discard_on  ActiveJob::DeserializationError,
              Octokit::InvalidRepository,
              Octokit::NotFound,
              Octokit::Unauthorized

  def perform(website_id)
    website = Communication::Website.find_by(id: website_id)
    return if website.nil?
    puts Git::MediaAndFilesChecker.new(website).report
  end
end
