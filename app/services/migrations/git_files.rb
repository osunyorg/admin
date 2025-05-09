class Migrations::GitFiles
  def self.migrate_all
    Communication::Website::GitFile.find_each do |git_file|
      migrate_git_file(git_file)
    end
  end

  def self.migrate_one(id)
    migrate_git_file Communication::Website::GitFile.find(id)
  end

  protected

  def migrate_git_file(git_file)
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