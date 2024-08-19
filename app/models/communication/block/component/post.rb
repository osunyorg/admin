class Communication::Block::Component::Post < Communication::Block::Component::Base

  def post
    return unless website
    website.posts.published_now_in(template.block.language).find_by(id: data)
  end

  def dependencies
    [post]
  end

end
