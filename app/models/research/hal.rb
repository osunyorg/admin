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
      job_class = GoodJob::Job.first.serialized_params["job_class"]
      publication_arg = GoodJob::Job.first.serialized_params["arguments"].detect { |arg|
        arg["_aj_globalid"].include?("Research::Publication")
      }

      if job_class == "Communication::Website::IndirectObject::SyncWithGitJob" && publication_arg.present?
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
