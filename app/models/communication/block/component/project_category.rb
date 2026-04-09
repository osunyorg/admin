class Communication::Block::Component::ProjectCategory < Communication::Block::Component::BaseReference

  def categories
    @categories ||= website.portfolio_categories
  end

  def category
    return unless website
    categories.find_by(id: data)
  end

  def dependencies
    [category]
  end

end
