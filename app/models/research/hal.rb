module Research::Hal
  extend ActiveModel::Naming
  extend ActiveModel::Translation

  def self.table_name_prefix
    'research_hal_'
  end

  def self.update_from_api!
    Research::Hal::Author.find_each do |author|
      author.import_research_hal_publications!
    end
    University::Person.joins(:research_hal_authors).distinct.find_each do |person|
      person.connect_research_hal_publications!
    end
  end

  def self.clear_queue!
    ids = []
    indirect_object_sync_job_class = "Communication::Website::IndirectObject::SyncWithGitJob"
    GoodJob::Job.queued.where(job_class: indirect_object_sync_job_class).find_each do |job|
      job_arguments = job.serialized_params["arguments"]
      job_options_argument = job_arguments.last
      indirect_object_gid = job_options_argument.dig("indirect_object", "_aj_globalid").to_s
      ids << job.id if indirect_object_gid.include?("Research::Publication")
    end
    GoodJob::Job.where(id: ids).destroy_all
  end

  def self.parts
    [
      [Research::Hal::Author, :admin_research_hal_authors_path],
    ]
  end
end
