class Communication::Block::Component::ProjectCategory < Communication::Block::Component::Base

  def category
    return unless website
    website.portfolio_categories
           .published_now_in(template.block.language)
           .find_by(id: data)
  end

  def dependencies
    [category]
  end

end
