class Communication::Block::Component::Project < Communication::Block::Component::Base

  def project
    return unless website
    website.projects
           .tmp_original # TODO L10N: to remove
           .published_now_in(template.block.language)
           .find_by(id: data)
  end

  def dependencies
    [project]
  end

end
