# Donne la capacité de se synchroniser avec Git lors d'une opération ActiveRecord
# Utilisé par :
# - website
# - objets directs
module WithGit
  extend ActiveSupport::Concern

  def sync_with_git
    Communication::Website::DirectObject::SyncWithGitJob.perform_later(website.id, direct_object: self)
  end

  def sync_with_git_safely
    return unless should_sync_with_git?
    Communication::Website::GitFile.generate website, self
    recursive_dependencies(syncable_only: true).each do |object|
      Communication::Website::GitFile.generate website, object
    end
    references.each do |object|
      Communication::Website::GitFile.generate website, object
    end
    website.git_repository.sync!
  end

  protected

  def should_sync_with_git?
    website.git_repository.valid? && syncable?
  end
end
