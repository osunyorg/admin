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
    Research::Publication.skip_callback :save, :after, :connect_and_sync_direct_sources
  end

  def self.unpause_git_sync
    Research::Publication.set_callback :save, :after, :connect_and_sync_direct_sources
  end

  def self.clear_queue!
    ids = []
    GoodJob::Job.find_each do |job|
      job_class = job.job_class
      job_arguments = job.serialized_params["arguments"]
      indirect_object_gid = job_arguments.last["_aj_globalid"].to_s

      if job_class == "Communication::Website::IndirectObject::SyncWithGitJob" &&
         indirect_object_gid.include?("Research::Publication")
        ids << job.id
      end
    end
    GoodJob::Job.where(id: ids).destroy_all
  end

  def self.parts
    [
      [Research::Hal::Author, :admin_research_hal_authors_path],
    ]
  end
end
