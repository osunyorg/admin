class Communication::Block::Component::AgendaCategory < Communication::Block::Component::BaseReference

  def categories
    @categories ||= website.agenda_categories
  end

  def category
    return unless website
    categories.find_by(id: data)
  end

  def dependencies
    [category]
  end

end
