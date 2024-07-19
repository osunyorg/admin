class Communication::Block::Component::Post < Communication::Block::Component::Base

  def post
    return unless website
    website.posts.published.find_by(id: data)
  end

  def dependencies
    [post]
  end

end
