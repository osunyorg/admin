class Communication::Block::Component::Organization < Communication::Block::Component::BaseReference

  def organization
    template.block
            .university
            .organizations
            .find_by(id: data)
  end

  def dependencies
    [organization]
  end

end
