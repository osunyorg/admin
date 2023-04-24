module WithDependenciesSynchronization
  extend ActiveSupport::Concern

  included do
    include WithDependencies

    attr_accessor :dependencies_before_save

    # TODO
    # before_save :compute_dependencies_before_save
    # after_save :cleanup_websites, if: :lost_dependencies_after_save?
    after_destroy :cleanup_websites
  end

  protected

  def compute_dependencies_before_save
    @dependencies_before_save = begin
      array = []
      array = self.class.find(id).recursive_dependencies_syncable if persisted?
      array.select { |dependency| dependency.respond_to?(:git_files) }
    end
  end

  def lost_dependencies_after_save?
    lost_dependencies_after_save = @dependencies_before_save - recursive_dependencies_syncable
    lost_dependencies_after_save.any?
  end

  def cleanup_websites
    # byebug unless is_a?(Communication::Block)
    if is_direct_object?
      website.destroy_obsolete_git_files
    else
      websites.each(&:destroy_obsolete_git_files)
    end
  end

end
