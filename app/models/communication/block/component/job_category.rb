class Communication::Block::Component::JobCategory < Communication::Block::Component::BaseReference

  def categories
    website.jobboard_categories
           .published_now_in(template.block.language)
  end

  def category
    return unless website
    categories.find_by(id: data)
  end

  def dependencies
    [category]
  end

end
