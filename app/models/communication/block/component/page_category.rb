class Communication::Block::Component::PageCategory < Communication::Block::Component::Base

  def categories
    @categories ||= website.page_categories
  end

  def category
    return unless website
    categories.find_by(id: data)
  end

  def dependencies
    [category]
  end

end
