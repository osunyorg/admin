class Communication::Block::Component::Event < Communication::Block::Component::Base

  def event
    return unless website
    website.events.published.find_by(id: data)
  end

  def dependencies
    [event]
  end

  def translate!
    return unless website && data.present?
    source_event = website.pages.find_by(id: data)
    @data = source_event.find_or_translate!(template.language).id if source_event.present?
  end

end
