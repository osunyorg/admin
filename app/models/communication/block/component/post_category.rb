class Communication::Block::Component::PostCategory < Communication::Block::Component::Base

  def category
    return unless website
    website.post_categories
           .tmp_original # TODO L10N: to remove
           .find_by(id: data)
  end

  def dependencies
    [category]
  end

end
