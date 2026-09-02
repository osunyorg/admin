# Vérifie, pour un site, que les git_files des médias et des fichiers
# marqués comme à jour existent bien sur le dépôt Git.
# Ceux qui n'y sont pas sont repassés en désynchronisés : la tâche
# `auto:synchronize_websites` les repoussera sur le dépôt.
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
    checker = Git::MediaAndFilesChecker.new(website)
    puts checker.report
    desynchronize! checker.missing_git_files
  end

  protected

  # Les git_files sont déjà générés, leur contenu est toujours attaché :
  # les marquer désynchronisés suffit à ce que l'analyzer les recrée
  # (current_path absent du dépôt et pas de déplacement => should_create?).
  def desynchronize!(git_files)
    return if git_files.empty?
    now = Time.zone.now
    Communication::Website::GitFile.where(id: git_files.map(&:id))
                                   .update_all(
                                     desynchronized: true,
                                     desynchronized_at: now,
                                     updated_at: now
                                   )
    puts "  => #{git_files.size} git_files repassés en désynchronisés."
  end
end
