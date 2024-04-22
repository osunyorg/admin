class Communication::Block::Component::Location < Communication::Block::Component::Base

  def location
    template.block.university.administration_locations.find_by(id: data)
  end

  def dependencies
    [location]
  end

  def translate!
    # TODO: Traduction à faire
  end
end
