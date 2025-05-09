# TODO supprimer après déploiement de l'itération 11 (mai 2025)
class Communication::Website::GitFile::MigrateJob < ApplicationJob
  def perform(git_file)
    return if git_file.current_content_file.attached?
    puts git_file.id
    ActiveStorage::Utils.attach_from_text(
      git_file.current_content_file, 
      git_file.computed_content, 
      'file.html'
    )
    desynchronized =  git_file.computed_path != git_file.previous_path || 
                      git_file.computed_sha != git_file.previous_sha
    if desynchronized
      git_file.update(
        current_path: git_file.computed_path,
        current_sha: git_file.computed_sha,
        desynchronized: true,
        desynchronized_at: Time.zone.now
      )
    else
      git_file.update(
        current_path: git_file.computed_path,
        current_sha: git_file.computed_sha,
        desynchronized: false,
        desynchronized_at: nil
      )
    end
  end
end
