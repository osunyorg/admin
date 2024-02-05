module Research
  extend ActiveModel::Naming
  extend ActiveModel::Translation

  def self.table_name_prefix
    'research_'
  end

  def self.parts
    [
      [University::Person::Researcher, :admin_research_researchers_path],
      [Research::Laboratory, :admin_research_laboratories_path],
      [Research::Thesis, :admin_research_theses_path],
      [Research::Journal, :admin_research_journals_path],
      [Research::Publication, :admin_research_publications_path],
    ]
  end
end
