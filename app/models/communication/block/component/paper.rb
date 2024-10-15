class Communication::Block::Component::Paper < Communication::Block::Component::Base

  def paper
    return unless website
    website.research_papers.find_by(id: data)
  end

  def dependencies
    [paper]
  end

end
