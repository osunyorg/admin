class Communication::Block::Component::Post < Communication::Block::Component::Base

  def post
    return unless website
    website.posts
           .tmp_original # TODO L10N: to remove
           .published_now_in(template.block.language)
           .find_by(id: data)
  end

  def dependencies
    [post]
  end

end
