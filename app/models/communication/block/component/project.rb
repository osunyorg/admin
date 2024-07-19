class Communication::Block::Component::Project < Communication::Block::Component::Base

  def project
    return unless website
    website.projects.published.find_by(id: data)
  end

  def dependencies
    [project]
  end

end
