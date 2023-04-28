# Donne la capacité de se synchroniser avec Git lors d'une opération ActiveRecord
# Utilisé par :
# - website
# - objets directs
module WithGit
  extend ActiveSupport::Concern

  def save_and_sync
    if save
      sync_with_git
      true
    else
      false
    end
  end

  def update_and_sync(params)
    if update(params)
      sync_with_git
      true
    else
      false
    end
  end

  def sync_with_git
    return unless website.git_repository.valid?
    if syncable?
      Communication::Website::GitFile.sync website, self
      recursive_dependencies(syncable_only: true).each do |object|
        Communication::Website::GitFile.sync website, object
      end
      references.each do |object|
        Communication::Website::GitFile.sync website, object
      end
    end
    website.git_repository.sync!
  end
  handle_asynchronously :sync_with_git, queue: 'default'

end
