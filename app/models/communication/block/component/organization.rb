class Communication::Block::Component::Organization < Communication::Block::Component::Base

  def organization
    template.block.university.organizations.find_by(id: data)
  end

  def git_dependencies
    [organization, organization&.logo&.blob]
  end

end
