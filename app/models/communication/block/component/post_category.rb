class Communication::Block::Component::PostCategory < Communication::Block::Component::BaseReference

  def categories
    @categories ||= website.post_categories
  end

  def category
    return unless website
    categories.find_by(id: data)
  end

  def dependencies
    [category]
  end

end
