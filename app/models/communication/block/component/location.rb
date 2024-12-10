class Communication::Block::Component::Location < Communication::Block::Component::BaseReference

  def location
    template.block.university.administration_locations.find_by(id: data)
  end

  def dependencies
    [location]
  end

end
