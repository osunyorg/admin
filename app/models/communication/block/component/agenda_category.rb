class Communication::Block::Component::AgendaCategory < Communication::Block::Component::BaseReference

  def category
    return unless website
    website.agenda_categories.find_by(id: data)
  end

  def dependencies
    [category]
  end

end
