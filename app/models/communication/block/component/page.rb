class Communication::Block::Component::Page < Communication::Block::Component::Base

  def page
    return unless website
    website.pages.published.find_by(id: data)
  end

end
