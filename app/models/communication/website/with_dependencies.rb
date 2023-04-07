module Communication::Website::WithDependencies
  extend ActiveSupport::Concern

  def sync_obsolete_dependencies
    all_dependencies = recursive_dependencies
    syncable_dependencies = recursive_dependencies(syncable_only: true)
    obsolete_dependencies = all_dependencies - syncable_dependencies
    return unless obsolete_dependencies.any?
    obsolete_dependencies.each do |dependency|
      Communication::Website::GitFile.sync self, dependency, destroy: true
    end
    self.git_repository.sync!
  end
  handle_asynchronously :sync_obsolete_dependencies, queue: :default

end
