module Research::Hal
  extend ActiveModel::Naming
  extend ActiveModel::Translation

  def self.table_name_prefix
    'research_hal_'
  end

  def self.update_from_api!
    begin
      Research::Hal::Publication.skip_callback :save, :after, :connect_and_sync_direct_sources
      Research::Hal::Author.find_each do |author|
        author.import_research_hal_publications!
      end
    ensure
      Research::Hal::Publication.set_callback :save, :after, :connect_and_sync_direct_sources
    end
  end

  def self.parts
    [
      [Research::Hal::Publication, :admin_research_hal_publications_path],
      [Research::Hal::Author, :admin_research_hal_authors_path],
    ]
  end
end
