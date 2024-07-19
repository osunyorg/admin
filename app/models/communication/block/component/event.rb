class Communication::Block::Component::Event < Communication::Block::Component::Base

  def event
    return unless website
    website.events.published.find_by(id: data)
  end

  def dependencies
    [event]
  end

end
