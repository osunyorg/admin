class Communication::Block::Component::Event < Communication::Block::Component::Base

  def event
    return unless website
    # TODO L10N : Handle publication state
    website.events.find_by(id: data)
  end

  def dependencies
    [event]
  end

end
