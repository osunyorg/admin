class Communication::Block::Component::Person < Communication::Block::Component::BaseReference

  def person
    template.block
            .university
            .people
            .find_by(id: data)
  end

  def dependencies
    [person]
  end

end
