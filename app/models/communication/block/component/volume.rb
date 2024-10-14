class Communication::Block::Component::Volume < Communication::Block::Component::Base

  def volume
    return unless website
    website.research_volumes.find_by(id: data)
  end

  def dependencies
    [volume]
  end

end
