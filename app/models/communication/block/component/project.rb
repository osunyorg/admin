class Communication::Block::Component::Project < Communication::Block::Component::Base

  def project
    return unless website
    website.projects.published.find_by(id: data)
  end

  def dependencies
    [project]
  end

  def translate!
    return unless website && data.present?
    source_project = website.projects.find_by(id: data)
    @data = source_project.find_or_translate!(template.language).id if source_project.present?
  end

end
