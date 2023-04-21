module WithDependenciesSynchronization
  extend ActiveSupport::Concern

  included do
    include WithDependencies

    attr_accessor :dependencies_before_save

    before_save :compute_dependencies_before_save
    after_save :cleanup_websites if :dependencies_missing_after_save?
    after_destroy :cleanup_websites

  end


  protected

  def compute_dependencies_before_save
    @dependencies_before_save = recursive_dependencies_syncable
  end

  def dependencies_missing_after_save?
    (@dependencies_before_save - recursive_dependencies_syncable).any?
  end

  def cleanup_websites
    # TODO
  end
  


end