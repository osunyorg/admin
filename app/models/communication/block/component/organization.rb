class Communication::Block::Component::Organization < Communication::Block::Component::Base

  def organization
    template.block.university.organizations.find_by(id: data)
  end

  def dependencies
    [organization]
  end

  def translate!
    # TODO: Traduction des Organisations à faire
  end

end
