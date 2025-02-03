class Communication::Block::Component::Category < Communication::Block::Component::Base

  def category
    return unless website
    website.page_categories
           .find_by(id: data)
  end

  def dependencies
    [category]
  end

end
