class Communication::Block::Component::Organization < Communication::Block::Component::Base

  def organization
    template.block.university.organizations.find_by(id: data)
  end

end
