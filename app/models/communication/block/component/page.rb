class Communication::Block::Component::Page < Communication::Block::Component::Base

  def page
    return unless website
    website.pages.published.find_by(id: data)
  end

  def git_dependencies
    [page, page&.best_featured_image&.blob]
  end

end
