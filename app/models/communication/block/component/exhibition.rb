class Communication::Block::Component::Exhibition < Communication::Block::Component::Base

  def event
    return unless website
    website.exhibitions
           .published_now_in(template.block.language)
           .find_by(id: data)
  end

  def dependencies
    [exhibition]
  end

end
