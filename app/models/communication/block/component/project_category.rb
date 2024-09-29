class Communication::Block::Component::ProjectCategory < Communication::Block::Component::Base

  def category
    return unless website
    website.portfolio_categories
           .tmp_original # TODO L10N: to remove
           .published_now_in(template.block.language)
           .find_by(id: data)
  end

  def dependencies
    [category]
  end

end
