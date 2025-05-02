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

  def self.parts
    [
      [Research::Hal::Author, :admin_research_hal_authors_path],
    ]
  end
end
