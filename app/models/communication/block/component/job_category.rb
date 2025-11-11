class Communication::Block::Component::JobCategory < Communication::Block::Component::BaseReference

  def categories
    @categories ||= website.jobboard_categories
  end

  def category
    return unless website
    categories.find_by(id: data)
  end

  def dependencies
    [category]
  end

end
