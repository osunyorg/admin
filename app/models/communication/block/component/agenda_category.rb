class Communication::Block::Component::AgendaCategory < Communication::Block::Component::Base

  def category
    return unless website
    website.agenda_categories
           .tmp_original # TODO L10N: to remove
           .find_by(id: data)
  end

  def dependencies
    [category]
  end

end
