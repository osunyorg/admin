module Communication::Website::WithRealmResearch
  extend ActiveSupport::Concern

  def blocks_from_research
    Communication::Block.where(about: research_papers)
  end

  def research_volumes
    has_research_volumes? ? about.volumes : Research::Journal::Volume.none
  end

  def research_papers
    has_research_papers? ? about.papers : Research::Journal::Paper.none
  end

  def researchers
    has_researchers? ? about.researchers : University::Person.none
  end

  def has_researchers?
    about && about.has_researchers?
  end

  def has_research_papers?
    about && about.has_research_papers?
  end

  def has_research_volumes?
    about && about.has_research_volumes?
  end

end