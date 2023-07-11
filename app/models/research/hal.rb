module Research::Hal
  extend ActiveModel::Naming
  extend ActiveModel::Translation

  def self.table_name_prefix
    'research_hal_'
  end

  def self.update_from_api!
    begin
      pause_git_sync
      Research::Hal::Author.find_each do |author|
        author.import_research_hal_publications!
      end
    ensure
      unpause_git_sync
    end
  end

  def self.pause_git_sync
    Research::Hal::Publication.skip_callback :save, :after, :connect_and_sync_direct_sources
  end

  def self.unpause_git_sync
    Research::Hal::Publication.set_callback :save, :after, :connect_and_sync_direct_sources
  end

  def self.clear_queue!
    ids = []
    Delayed::Job.find_each do |job|
      next unless job.public_respond_to?(:payload_object)
      if  job.payload_object.method_name == :sync_indirect_object_with_git_without_delay &&
          job.payload_object.args.first.is_a?(Research::Hal::Publication)
        ids << job.id
      end
    end
    Delayed::Job.where(id: ids).destroy_all
  end

  def self.parts
    [
      [Research::Hal::Publication, :admin_research_hal_publications_path],
      [Research::Hal::Author, :admin_research_hal_authors_path],
    ]
  end
end
