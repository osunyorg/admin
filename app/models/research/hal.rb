module Research::Hal
  extend ActiveModel::Naming
  extend ActiveModel::Translation

  def self.table_name_prefix
    'research_hal_'
  end

  def self.update_from_api!
    # TODO suspendre les mises à jour des objets indirects
    Research::Hal::Author.find_each do |author|
      author.import_research_hal_publications!
    end
    # TODO remettre la mise à jour des objects indirects
  end

  def self.parts
    [
      [Research::Hal::Publication, :admin_research_hal_publications_path],
      [Research::Hal::Author, :admin_research_hal_authors_path],
    ]
  end
end
