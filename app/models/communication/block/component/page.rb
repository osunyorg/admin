class Communication::Block::Component::Page < Communication::Block::Component::Base
  def page
    return unless website
    website.pages.published_now_in(template.block.language).find_by(id: data)
  end

  def dependencies
    [page]
  end

end
