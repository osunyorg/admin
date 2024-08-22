class Communication::Block::Component::Page < Communication::Block::Component::Base
  def page
    return unless website
    website.pages
           .tmp_original # TODO L10N: to remove
           .published_now_in(template.block.language)
           .find_by(id: data)
  end

  def dependencies
    [page]
  end

end
