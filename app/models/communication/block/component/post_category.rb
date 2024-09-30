class Communication::Block::Component::PostCategory < Communication::Block::Component::Base

  def category
    return unless website
    website.post_categories
           .find_by(id: data)
  end

  def dependencies
    [category]
  end

end
